import 'package:flutter_google_maps/flutter_google_maps.dart';

class SocketLocation {
  String id;
  double lat;
  double long;

  Marker get marker =>
      lat != null && long != null ? Marker(GeoCoord(lat, long)) : null;

  SocketLocation({
    this.id,
    this.lat,
    this.long,
  });

  SocketLocation copyWith({
    String id,
    double lat,
    double long,
  }) =>
      SocketLocation(
        id: id ?? this.id,
        lat: lat ?? this.lat,
        long: long ?? this.long,
      );

  SocketLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}
