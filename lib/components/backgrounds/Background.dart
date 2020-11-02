import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_useful_things/components/backgrounds/BackgroundThemes.dart';
import 'package:flutter_useful_things/components/inputs/InputText.dart';
import 'package:flutter_useful_things/constants/Colors.dart' as Constants;
import 'package:flutter_useful_things/utils/Functions.dart';

class Background extends StatelessWidget{
  Background({
    Key key,
    this.child,
    this.title,
    this.showDrawer = false,
    this.theme,
    this.onNavigationClick,
    this.actions,
    this.bottomNavigation,
    this.onWillPop,
    this.bottomSheet,
    this.floatingActionButton,
    this.centerTitle = true,
    this.hasAppbar = true,
    this.flexibleSpace,
    this.leading
  }) : super(key: key);

  final bool centerTitle;
  final bool hasAppbar;
  final Widget child;
  final Widget title;
  final Widget bottomSheet;
  final bool showDrawer;
  final Function onNavigationClick;
  final List<Widget> actions;
  final Widget bottomNavigation;
  final BackgroundThemes theme;
  final WillPopCallback onWillPop;
  final FloatingActionButton floatingActionButton;
  final Widget flexibleSpace;
  final Widget leading;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    BackgroundThemes _theme = theme ?? BackgroundThemes.main;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: _theme.decoration,
            clipBehavior: Clip.hardEdge,
          ),
          Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            bottomNavigationBar: bottomNavigation,
            floatingActionButton: floatingActionButton,
            appBar: (hasAppbar? (
              AppBar(
                centerTitle: centerTitle,
                iconTheme: IconThemeData(color: _theme.titleColor),
                textTheme: TextTheme(headline6: TextStyle(color: _theme.titleColor, fontSize: 20, fontFamily: "lato")),
                title: title,
                backgroundColor: _theme.appBarColor,
                brightness: Brightness.dark,
                elevation: 0,
                leading: leading,
                actions: actions,
                flexibleSpace: flexibleSpace,
              )
            ) : null),
            body: child,
            drawer: (showDrawer?
              Drawer(
                child: Container(
                  color: Colors.red,
                ),
              ) : null
            ),
          ),
        ],
      ),
    );
  }
}

//class BackgroundTheme {
//
//  static BackgroundTheme main = BackgroundTheme(
//    titleColor: Colors.white,
//    decoration: BoxDecoration(
//      gradient: LinearGradient(
//        begin: Alignment.topCenter,
//        end: Alignment.bottomCenter,
//        colors: [
//          Constants.Colors.GRADIENT_BACKGROUND_INI,
//          Constants.Colors.GRADIENT_BACKGROUND_END
//        ]
//      )
//    )
//  );
//
//  static BackgroundTheme details = BackgroundTheme(
//    titleColor: Constants.Colors.COLOR_PRIMARY,
//    decoration: BoxDecoration(
//      color: Constants.Colors.BACKGROUND_MARBLE_HIGH
//    )
//  );
//
//  static BackgroundTheme test = BackgroundTheme(
//    titleColor: Constants.Colors.COLOR_PRIMARY,
//    decoration: BoxDecoration(
//      color: Colors.transparent
//    )
//  );
//
//  static BackgroundTheme loginPage = BackgroundTheme(
//    titleColor: Colors.black,
//    decoration: BoxDecoration(
////      color: Constants.Colors.BLACK_TRANSPARENT,
//        borderRadius: BorderRadius.only(
//            topRight: Radius.circular(20),
//            topLeft: Radius.circular(20)
//        )
//    )
//  );
//
//  BackgroundTheme({this.decoration, this.titleColor});
//
//  final BoxDecoration decoration;
//  final Color titleColor;
//}

class AppBarAction extends StatelessWidget{

  final Widget icon;
  final String imgPath;
  final Function onTap;

  AppBarAction({this.imgPath, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: (icon != null? icon : Image.asset(imgPath,
      width: 24,
      height: 24,
    )),
    onPressed: onTap,
  );
}