import '../env_config.dart';
import '_dev.dart' as _dev;
import '_prod.dart' as _prod;

abstract class Environment {
  static Future<EnvConfig> get dev => _dev.Config.create();
  static Future<EnvConfig> get prod => _prod.Config.create();
}
