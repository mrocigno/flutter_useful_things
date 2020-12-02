import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_useful_things/components/backgrounds/BackgroundTheme.dart';
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
    this.flexibleSpace,
    this.leading,
    this.appBarConfig
  }) : super(key: key);

  final bool centerTitle;
  final Widget child;
  final Widget title;
  final Widget bottomSheet;
  final bool showDrawer;
  final Function onNavigationClick;
  final List<Widget> actions;
  final Widget bottomNavigation;
  final BackgroundTheme theme;
  final WillPopCallback onWillPop;
  final FloatingActionButton floatingActionButton;
  final Widget flexibleSpace;
  final Widget leading;
  final AppBarConfig appBarConfig;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    BackgroundTheme _theme = theme ?? BackgroundTheme.main;

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
          (appBarConfig?.sliverConfig != null? (
            _SliverBackground(
              child: child,
              theme: _theme,
              scaffoldKey: _scaffoldKey,
              appBarConfig: appBarConfig,
              bottomNavigation: bottomNavigation,
              floatingActionButton: floatingActionButton,
            )
          ) : (appBarConfig != null? (
            _StaticBackground(
              child: child,
              theme: _theme,
              scaffoldKey: _scaffoldKey,
              appBarConfig: appBarConfig,
              bottomNavigation: bottomNavigation,
              floatingActionButton: floatingActionButton,
            )
          ) : null)),
        ],
      ),
    );
  }
}

class AppBarConfig {
  final bool isTitleCentralized;
  final Widget title;
  final Widget leading;
  final List<Widget> actions;
  final Widget flexibleSpace;
  final AppBarSliverConfig sliverConfig;

  AppBarConfig({
    this.isTitleCentralized,
    this.title,
    this.leading,
    this.actions,
    this.flexibleSpace,
    this.sliverConfig
  });
}

class AppBarSliverConfig {
  final bool isSnap;
  final bool isPinned;
  final bool isFloating;
  final double expandedHeight;

  AppBarSliverConfig({
    this.isSnap,
    this.isPinned,
    this.isFloating,
    this.expandedHeight
  });
}

class _StaticBackground extends StatelessWidget {

  final Key scaffoldKey;
  final Widget bottomNavigation;
  final FloatingActionButton floatingActionButton;
  final AppBarConfig appBarConfig;
  final BackgroundTheme theme;
  final Widget child;

  const _StaticBackground({
    Key key,
    this.scaffoldKey,
    this.bottomNavigation,
    this.floatingActionButton,
    this.appBarConfig,
    this.theme,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: bottomNavigation,
      floatingActionButton: floatingActionButton,
      appBar: (appBarConfig != null? (
          AppBar(
            centerTitle: appBarConfig.isTitleCentralized,
            iconTheme: IconThemeData(color: theme.titleColor),
            textTheme: TextTheme(headline6: TextStyle(color: theme.titleColor, fontSize: 20)),
            title: appBarConfig.title,
            backgroundColor: theme.appBarColor,
            brightness: Brightness.dark,
            elevation: 0,
            leading: appBarConfig.leading,
            actions: appBarConfig.actions,
            flexibleSpace: appBarConfig.flexibleSpace,
          )
      ) : null),
      body: child
    );
  }
}

class _SliverBackground extends StatelessWidget {

  final Key scaffoldKey;
  final Widget bottomNavigation;
  final FloatingActionButton floatingActionButton;
  final AppBarConfig appBarConfig;
  final BackgroundTheme theme;
  final Widget child;

  const _SliverBackground({
    Key key,
    this.scaffoldKey,
    this.bottomNavigation,
    this.floatingActionButton,
    this.appBarConfig,
    this.theme,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: bottomNavigation,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: appBarConfig.actions,
            brightness: theme.statusBarBrightness,
            floating: appBarConfig.sliverConfig.isFloating,
            pinned: appBarConfig.sliverConfig.isPinned,
            snap: appBarConfig.sliverConfig.isSnap,
            leading: appBarConfig.leading,
            expandedHeight: appBarConfig.sliverConfig.expandedHeight,
            centerTitle: theme.centralizeTitle,
            iconTheme: IconThemeData(color: theme.titleColor),
            title: appBarConfig.title,
            backgroundColor: theme.appBarColor,
            elevation: theme.elevation,
            flexibleSpace: appBarConfig.flexibleSpace,
          ),
          child
        ],
      ),
    );
  }
}


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