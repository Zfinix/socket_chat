import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme(BuildContext _) {
  return ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.manropeTextTheme(
      Theme.of(_).textTheme,
    ),
    primaryColor: Color(0xff5B428F),
    accentColor: Color(0xffF56D58),
    primaryColorDark: Color(0xff262833),
    primaryColorLight: Color(0xffFCF9F5),
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

Color get bg => Platform.isIOS ? Color(0xff242f3e) : Color(0xff17263c);
Color get altColor => Platform.isIOS ? Color(0xff17263c) : Color(0xff28263c);
