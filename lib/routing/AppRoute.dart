/*
* Created to flutter-components at 05/09/2020
*/
import "dart:developer" as dev;

import 'package:flutter/material.dart';
import 'package:flutter_useful_things/base/BaseBloc.dart';
import 'package:flutter_useful_things/base/BaseScreen.dart';

abstract class RouteObserverMixin {

  void onComeback() => {};

  void onCalled() => {};

  void onPause() => {};

  void onExit() => {};

}

class AppRoute extends RouteObserver<PageRoute<dynamic>> {

  static final Set<BaseScreen> _stack = {};

  static void register(BaseScreen screen){
    _stack.add(screen);
  }

  void _sendScreenView(PageRoute<dynamic> route, ScreenViewType type) {
    var screenName = route.settings.name;
    if(screenName != null) {
      var routeObserver = _stack.firstWhere((element) => element.name == screenName, orElse: () => null);
      switch(type){
        case ScreenViewType.COMEBACK: {
          routeObserver?.onComeback();
          break;
        }
        case ScreenViewType.CALLED: {
          routeObserver?.onCalled();
          break;
        }
        case ScreenViewType.PAUSING: {
          routeObserver?.onPause();
          break;
        }
        case ScreenViewType.EXITING: {
          routeObserver?.onExit();
          _stack.remove(routeObserver);
          break;
        }
      }
    }

  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute, ScreenViewType.COMEBACK);
      _sendScreenView(route, ScreenViewType.EXITING);
    }
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(route, ScreenViewType.CALLED);
      _sendScreenView(previousRoute, ScreenViewType.PAUSING);
    }
  }
  
  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    if(newRoute is PageRoute && oldRoute is PageRoute){
      _sendScreenView(newRoute, ScreenViewType.CALLED);
      _sendScreenView(oldRoute, ScreenViewType.EXITING);
    }
  }
}

enum ScreenViewType {
  COMEBACK,
  CALLED,
  EXITING,
  PAUSING
}