import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_chat/utils/log.dart';

import 'config/config_loader.dart';
import 'config/env_config.dart';
import 'views/home.dart';
import 'utils/theme.dart';

void mainCommon(EnvConfig envConfig) async {
  Log.init(kReleaseMode);
  GoogleMap.init(ConfigLoader.gApiKey);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Chat',
      theme: theme(context),
      home: MapHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
