import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:socket_chat/core/provider_registry.dart';
import 'package:socket_chat/core/viewmodels/map_vm.dart';

import '../core/raw/raw.dart';
import 'chat.dart';

class MapHome extends StatefulHookWidget {
  MapHome({Key key}) : super(key: key);

  @override
  _MapHomeState createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> with SingleTickerProviderStateMixin {
  MapViewModel get vm => context.read(mapVM);
  @override
  void initState() {
    super.initState();
    vm.tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );
    vm.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    var tabController = useProvider(mapVM.select((v) => v.tabController));
    return (tabController != null)
        ? TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [BaseSection(), ChatSection()],
          )
        : SpinKitFadingCube();
  }
}



class BaseSection extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final mapkey = useProvider(mapVM.select((v) => v.mapkey));
    final scaffoldKey = useProvider(mapVM.select((v) => v.scaffoldKey));
    final markers = useProvider(
        mapVM.select((v) => v.markers.map((e) => e.marker).toSet()));

    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            GoogleMap(
              key: mapkey,
              markers: markers,
              initialZoom: 12,
              mapType: MapType.roadmap,
              mapStyle: Platform.isIOS ? mapStyle : mapStyle2,
              interactive: true,
              onTap: (value) {
                context.read(mapVM).locationListen(value);
              },
              mobilePreferences: const MobileMapPreferences(
                  trafficEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false),
              webPreferences: WebMapPreferences(
                fullscreenControl: true,
                zoomControl: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 55),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    child: IconButton(
                      icon: Icon(FluentIcons.chat_28_filled),
                      onPressed: () => context.read(mapVM).openChat(context),
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 35,
                          color: Colors.blue.withOpacity(0.5),
                        )
                      ],
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        'GeoChat',
                        style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 30),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 45,
                    width: 45,
                    child: IconButton(
                      icon: Icon(FluentIcons.my_location_24_filled),
                      onPressed: context.read(mapVM).gotoMe,
                      color: Colors.green,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 35,
                          color: Colors.grey.withOpacity(0.5),
                        )
                      ],
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
