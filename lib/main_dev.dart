
import 'package:flutter/material.dart';

import 'config/env/env.dart';
import 'main_common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final envConfig = await Environment.dev;

  mainCommon(envConfig);
}
