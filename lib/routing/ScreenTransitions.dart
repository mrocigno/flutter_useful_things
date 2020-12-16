import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:flutter_useful_things/base/BaseScreen.dart';
import 'package:flutter_useful_things/routing/AppRoute.dart';

class ScreenTransitions {

  static void _registerObservers(BaseScreen screen) {
    if(screen is RouteObserverMixin){
      AppRoute.register(screen.name, screen);
    }
  }

  static Future<T> pushReplacement<T>(BuildContext context, BaseScreen screen, {Animations animation = Animations.FADE}){
    // _registerObservers(screen);
    return Navigator.pushReplacement(context, _getPageRoute<T>(screen, animation));
  }

  static Future<T> pushAndRemoveUntil<T>(BuildContext context, BaseScreen screen, {
    Animations animation = Animations.FADE,
    RoutePredicate predicate
  }) {
    return Navigator.pushAndRemoveUntil(context, _getPageRoute<T>(screen, animation), predicate ?? (route) => false);
  }

  static Future<T> push<T>(BuildContext context, BaseScreen screen, {Animations animation = Animations.SLIDE_DOWN}) {
    // _registerObservers(screen);
    return Navigator.push(context, _getPageRoute<T>(screen, animation));
  }

  static PageRouteBuilder<T> _getPageRoute<T>(BaseScreen screen, Animations animation) => PageRouteBuilder<T>(
    settings: RouteSettings(name: screen.name),
    pageBuilder: (context, animation, secondaryAnimation) => BaseScreenStateful(screen),
    transitionDuration: Duration(milliseconds: 300),
    transitionsBuilder: _getAnimation(animation),
  );

  static RouteTransitionsBuilder _getAnimation(Animations animation) {
    switch(animation){
      case Animations.SLIDE_DOWN: return (context, animation, secondaryAnimation, child) {
        Animation<Offset> offset = Tween<Offset>(
          begin: Offset(0, -1),
          end: Offset(0, 0),
        ).animate(animation);

        return SlideTransition(
            position: offset,
            child: child
        );
      };
      case Animations.SLIDE_UP: return (context, animation, secondaryAnimation, child) {
        Animation<Offset> offset = Tween<Offset>(
          begin: Offset(0, 1),
          end: Offset(0, 0),
        ).animate(animation);

        return SlideTransition(
            position: offset,
            child: child
        );
      };
      case Animations.FADE:
      default: return (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      };
    }
  }

}

enum Animations {
  FADE,
  SLIDE_DOWN,
  SLIDE_UP
}