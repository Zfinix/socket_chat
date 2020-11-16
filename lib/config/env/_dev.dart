import 'dart:async';

import '../config_loader.dart';
import '../env_config.dart';

class Config implements EnvConfig {
  Config._();

  static Future<EnvConfig> create() async {
    // read secrets
    await ConfigLoader.initialize();
    // return the new env Config
    return Config._();
  }

  @override
  String get name => 'DEV';

  @override
  String get hostURL => ConfigLoader.gApiKey;
}

