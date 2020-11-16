import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_chat/core/models/chat_model.dart';
import 'package:socket_chat/core/models/place_by_latlng.dart';
import 'package:socket_chat/core/models/socket_location.dart';
import 'package:socket_chat/core/models/typing_model.dart';
import 'package:socket_chat/core/network_layer/api/location.dart';
import 'package:socket_chat/widget/message_item.dart';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:username_gen/username_gen.dart';

class MapViewModel extends ChangeNotifier {
  TextEditingController txt = TextEditingController();

  final username = UsernameGen.gen();

  Location _locationApi = Location();

  final mapkey = GlobalKey<GoogleMapStateBase>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  MapOperations get map => GoogleMap.of(mapkey);
  bool get hasPlace => place != null;

  List<MessageItem> _messages = [];
  List<MessageItem> get messages => _messages;
  set messages(List<MessageItem> val) {
    _messages = val;
    notifyListeners();
  }

  Set<SocketLocation> _markers = {};
  Set<SocketLocation> get markers => _markers;
  set markers(Set<SocketLocation> val) {
    _markers = val;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Socket _socket;
  Socket get socket => _socket;
  set socket(Socket val) {
    _socket = val;
    notifyListeners();
  }

  PlaceByLatLang _place;
  PlaceByLatLang get place => _place;
  set place(PlaceByLatLang val) {
    _place = val;
    notifyListeners();
  }

  String _typing = '';
  String get typing => _typing;
  set typing(String val) {
    _typing = val;
    notifyListeners();
  }

  Timer _debounce;
  Timer get debounce => _debounce;
  set debounce(Timer val) {
    _debounce = val;
    notifyListeners();
  }

  TabController tabController;

  void getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.denied ||
          permission != LocationPermission.deniedForever) {
       // connectToServer();
      } else {
        await Geolocator.requestPermission();
        getLocation();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void gotoMe() async {
    try {
      var pos = await Geolocator.getCurrentPosition();
      map.moveCamera(GeoCoord(pos.latitude, pos.longitude));
      var req = await _locationApi.getPlaceDetail(
          coord: GeoCoord(pos.latitude, pos.longitude));

      req.fold((l) {
        showSnackBar('Error Loading', 5);
      }, (r) {
        place = r;
      });
    } catch (e) {}
  }

  void connectToServer() {
    try {
      socket = io('http://127.0.0.1:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('location', handleLocationListen);
      socket.on('typing', handleTyping);
      socket.on('message', handleMessage);
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));

      gotoMe();
    } catch (e) {
      print(e.toString());
    }
  }

  getPlace(GeoCoord coord) async {
    loading = true;
    var req = await _locationApi.getPlaceDetail(coord: coord);

    req.fold((l) {
      showSnackBar('Error Loading', 5);
    }, (r) {
      if (place != null &&
          place.results.length > 0 &&
          r != null &&
          r.results.length > 0)
        map.addDirection(
          r.results[0]?.formattedAddress,
          place.results[0]?.formattedAddress,
          startLabel: r.results[0]?.addressComponents[0]?.shortName,
          startInfo: r.results[0]?.formattedAddress,
          endInfo: place.results[0]?.formattedAddress,
        );
    });

    loading = false;
  }

  // Handle Location

  void locationListen(GeoCoord loc) {
    map.moveCamera(GeoCoord(loc.latitude, loc.longitude));
    sendLocation(SocketLocation(
      id: socket.id,
      lat: loc.latitude,
      long: loc.longitude,
    ));
  }

  sendLocation(SocketLocation skLocation) {
    socket.emit("location", skLocation.toJson());
  }

  handleLocationListen(_) async {
    final marker = SocketLocation.fromJson(_);
    if (!isMe(marker.id)) {
      map.moveCamera(GeoCoord(marker.lat, marker.long));
      getPlace(GeoCoord(marker.lat, marker.long));
      map.clearMarkers();
      map.addMarker(marker.marker);
      notifyListeners();
    }
  }

  // Handle Typing

  sendTyping(bool typing) {
    socket.emit(
        "typing",
        TypingModel(
          id: socket.id,
          username: username,
          typing: typing,
        ).toJson());
  }

  void handleTyping(data) {
    final typingModel = TypingModel.fromJson(data);

    if (!isMe(typingModel.id) && typingModel.typing) {
      typing = '${typingModel.username} is typing...';
    } else if (!isMe(typingModel.id) && !typingModel.typing) {
      typing = '';
    }
  }

  // Handle Messages

  sendMessage() {
    try {
      if (txt.text == null || txt.text.length == 0) {
        return;
      }
      sendTyping(false);
      socket.emit(
        "message",
        ChatModel(
          id: socket.id,
          message: txt.text,
          timestamp: DateTime.now(),
          username: username,
        ).toJson(),
      );
      txt.clear();
    } catch (e) {}
  }

  void handleMessage(data) {
    try {
      var msg = ChatModel.fromJson(data);
      if (tabController.index == 0 && !isMe(msg.id))
        showToast('${msg.username}: ${msg.message}',
            context: scaffoldKey.currentContext,
            animation: StyledToastAnimation.slideFromTop,
            reverseAnimation: StyledToastAnimation.slideToTop,
            position: StyledToastPosition.bottom,
            startOffset: Offset(0.0, -3.0),
            reverseEndOffset: Offset(0.0, -3.0),
            duration: Duration(seconds: 4),
            //Animation duration   animDuration * 2 <= duration
            animDuration: Duration(seconds: 1),
            curve: Curves.elasticOut,
            reverseCurve: Curves.fastOutSlowIn);

      messages.insert(
        0,
        MessageItem(
          isMe: isMe(msg.id),
          message: msg,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  bool isMe(String id) => id == socket.id;
  void showSnackBar(String data, [int time, Function onTap]) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: GestureDetector(
        child: Text(
          '$data',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap ?? () {},
      ),
      duration: Duration(seconds: time ?? 7),
    ));
  }

  void openChat(context) {
    tabController.animateTo(1);
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
}
