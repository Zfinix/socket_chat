import 'package:meta/meta.dart';

class Log {
  factory Log() => _instance;

  Log._(this.production);

  static void init([bool production = false]) => _instance = Log._(production);

  static Log _instance;

  final bool production;

  String debug(String tag, [dynamic payload]) {
    final output = generator('=', tag, payload);
    print(output);
    return output;
  }

  String error(String tag, [dynamic payload]) {
    final output = generator('*', tag, payload);
    print(output);
    return output;
  }

  @visibleForTesting
  String generator(String delim, String tag, [dynamic payload]) {
    var _ = '';
    if (!production) {
      final _d = delim.padRight(20, delim);
      _ += '\n$delim $tag $_d\n';
      if (payload != null) {
        _ += '$payload \n$_d\n';
      }
    }

    return _;
  }
}
