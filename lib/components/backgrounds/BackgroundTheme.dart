

import 'package:flutter/material.dart';
import 'package:flutter_useful_things/constants/Colors.dart' as Constants;

class BackgroundTheme {

  static BackgroundTheme main = BackgroundTheme(
    statusBarBrightness: Brightness.dark,
    centralizeTitle: true,
    titleColor: Colors.white,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Constants.Colors.GRADIENT_BACKGROUND_INI,
          Constants.Colors.GRADIENT_BACKGROUND_END
        ]
      )
    )
  );

  static BackgroundTheme details = BackgroundTheme(
    statusBarBrightness: Brightness.light,
    centralizeTitle: true,
    pinned: true,
    elevation: 3,
    appBarColor: Constants.Colors.PRIMARY_SWATCH,
    titleColor: Constants.Colors.BACKGROUND_MARBLE_HIGH,
    decoration: BoxDecoration(
      color: Constants.Colors.BACKGROUND_MARBLE_LOW
    )
  );

  static BackgroundTheme search = BackgroundTheme(
    statusBarBrightness: Brightness.light,
    centralizeTitle: true,
    pinned: true,
    titleColor: Constants.Colors.PRIMARY_SWATCH,
    appBarColor: Constants.Colors.WHITE_TRANSPARENT_HIGH,
    elevation: 0,
    decoration: BoxDecoration(
      color: Constants.Colors.BACKGROUND_MARBLE_MEDIUM
    )
  );

  static BackgroundTheme loginPage = BackgroundTheme(
    statusBarBrightness: Brightness.light,
    centralizeTitle: false,
    titleColor: Colors.black,
    decoration: BoxDecoration(
//      color: Constants.Colors.BLACK_TRANSPARENT,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20)
        )
    )
  );

  BackgroundTheme({this.decoration, this.centralizeTitle, this.titleColor, this.statusBarBrightness, this.pinned = false, this.elevation = 1, this.appBarColor = Colors.transparent});

  final BoxDecoration decoration;
  final bool centralizeTitle;
  final Color titleColor;
  final Brightness statusBarBrightness;
  final bool pinned;
  final double elevation;
  final Color appBarColor;

}