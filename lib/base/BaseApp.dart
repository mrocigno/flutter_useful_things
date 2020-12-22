import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_useful_things/base/BaseScreen.dart';
import 'package:flutter_useful_things/di/Injection.dart';
import 'package:flutter_useful_things/routing/AppRoute.dart';

class BaseApp extends StatefulWidget {

  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeData highContrastDarkTheme;
  final ThemeData highContrastTheme;

  final ThemeMode themeMode;

  final Color color;

  final Key key;

  final String title;

  final Map<Type, Action<Intent>> actions;

  final TransitionBuilder builder;

  final Locale locale;
  final LocaleListResolutionCallback localeListResolutionCallback;
  final LocaleResolutionCallback localeResolutionCallback;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

  final bool checkerboardOffscreenLayers;
  final bool checkerboardRasterCacheImages;
  final bool debugShowCheckedModeBanner;
  final bool debugShowMaterialGrid;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;

  final BaseScreen home;
  final Widget homePlaceholder;

  final Map<LogicalKeySet, Intent> shortcuts;
  final Iterable<Locale> supportedLocales;
  final InjectionInitializer injectionInitializer;

  BaseApp({
    this.home,
    this.builder,
    this.title = '',
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.key,
    this.homePlaceholder,
    this.injectionInitializer,
  });

  @override
  _BaseAppState createState() => _BaseAppState();

}

class _BaseAppState extends State<BaseApp> {

  Future<bool> futureInitializer;

  @override
  void initState() {
    super.initState();
    if (widget.injectionInitializer != null) {
      futureInitializer = Injection.initialize(widget.injectionInitializer);
    } else {
      futureInitializer = Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: widget.key,
      theme: widget.theme,
      color: widget.color,
      title: widget.title,
      actions: widget.actions,
      builder: widget.builder,
      checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
      checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
      darkTheme: widget.darkTheme,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      debugShowMaterialGrid: widget.debugShowMaterialGrid,
      highContrastDarkTheme: widget.highContrastDarkTheme,
      highContrastTheme: widget.highContrastTheme,
      locale: widget.locale,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      localeResolutionCallback: widget.localeResolutionCallback,
      localizationsDelegates: widget.localizationsDelegates,
      navigatorObservers: [AppRoute()],
      onGenerateRoute: (initialRoute) {
        AppRoute.register(widget.home);
        return PageRouteBuilder(
          settings: RouteSettings(name: widget.home.name),
          pageBuilder: (context, animation, secondaryAnimation) => transformHome,
        );
      },
      shortcuts: widget.shortcuts,
      showPerformanceOverlay: widget.showPerformanceOverlay,
      showSemanticsDebugger: widget.showSemanticsDebugger,
      supportedLocales: widget.supportedLocales,
      themeMode: widget.themeMode,
    );
  }

  Widget get transformHome {
    final home = BaseScreenStateful(widget.home);
    return (widget.injectionInitializer != null? (
        FutureBuilder<bool>(
          future: futureInitializer,
          initialData: false,
          builder: (context, snapshot) {
            bool data = snapshot.data;
            if (!data || snapshot.connectionState != ConnectionState.done) return widget.homePlaceholder ?? Wrap();
            return home;
          },
        )
    ) : home);
  }

}