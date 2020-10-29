import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_chat/core/raw/raw.dart';
import 'package:socket_chat/utils/log.dart';

import 'config/config_loader.dart';
import 'views/home.dart';
import 'utils/theme.dart';

void main() {
  ConfigLoader.initialize();
  Log.init(kReleaseMode);
  GoogleMap.init(ConfigLoader.gApiKey);
  WidgetsFlutterBinding.ensureInitialized();
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
