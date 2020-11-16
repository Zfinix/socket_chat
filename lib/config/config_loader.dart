import 'dart:convert';

import 'package:flutter/services.dart';

class ConfigLoader {
  static Map<String, dynamic> _config;

  static Future<void> initialize() async {
    try {
      final configString =
          await rootBundle.loadString('config/app_config.json');
      _config = json.decode(configString) as Map<String, dynamic>;
    } catch (e) {
      print(e.toString());
    }
  }

  static String get gApiKey => _config['gApiKey'] as String;
}
