import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_useful_things/base/BaseBloc.dart';
import 'package:flutter_useful_things/base/BaseFragment.dart';
import 'package:flutter_useful_things/di/Injection.dart';
import 'package:flutter_useful_things/routing/AppRoute.dart';

class BaseScreenStateful extends StatefulWidget {

  final BaseScreen state;

  BaseScreenStateful(this.state, {Key key}) : super(key: key);

  @override
  BaseScreen createState() => state;

}

abstract class BaseScreen<T extends BaseBloc> extends State<BaseScreenStateful> implements RouteObserverMixin {

  String get name;

  T bsBloc;

  static BaseScreen of(BuildContext context){
    _BaseScreenScope state = context.dependOnInheritedWidgetOfExactType<_BaseScreenScope>();
    return state.state;
  }

  Set<BaseFragment> _fragments = Set();
  void registerFragment(BaseFragment fragment){
    _fragments.add(fragment);
  }

  void unregisterFragment(BaseFragment fragment){
    _fragments.remove(fragment);
  }

  @override
  Widget build(BuildContext context) {
    return _BaseScreenScope(
      state: this,
      child: buildScreen(context),
    );
  }

  Widget buildScreen(BuildContext context);

  @override
  void onCalled() {
    _fragments.forEach((e) => e.onCalled());
  }

  @override
  void onComeback() {
    _fragments.forEach((e) => e.onComeback());
  }

  @override
  void onExit() {
    _fragments.forEach((e) => e.onExit());
    bsBloc?.close();
  }

  @override
  void onPause() {
    _fragments.forEach((e) => e.onPause());
  }
}

class _BaseScreenScope extends InheritedWidget {

  _BaseScreenScope({
    key,
    child,
    this.state,
  }) : super(key: key, child: child);

  final BaseScreen state;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}