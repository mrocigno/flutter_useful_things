
import 'dart:developer';

import 'package:flutter_useful_things/base/BaseBloc.dart';
import 'package:rxdart/rxdart.dart';

T inject<T>({String named}) => Injection.inject(named: named);

T bloc<T extends BaseBloc>({String named}) => Injection.inject(named: named);

T sharedBloc<T extends BaseBloc>({String named}) => Injection.inject(named: named, shared: true);

class Injection {

  // he will never be closed :((((
  // ignore: close_sinks
  static BehaviorSubject<bool> initialized = BehaviorSubject.seeded(false);

  static _ModuleConstructor _moduleConstructor = _ModuleConstructor();

  static initialize(InjectionInitializer initializer) async {
    await initializer(_moduleConstructor);
    initialized.value = true;
  }

  static T inject<T>({String named, bool shared = false}) {
    _Module module = _getModule<T>(named: named);
    switch(module.type){
      case 1: {
        return _getSingleton(module);
      }
      case 2: {
        return module.build();
      }
      case 3: {
        return _getBloc(module, shared);
      }
      default: {
        throw Exception("Type not definied");
      }
    }
  }
  
  static _Module _getModule<T>({String named}) {
    if(named != null){
      try {
        return _moduleConstructor._modules.singleWhere((element) => element.named == named);
      } catch (e) {
        throw Exception("Module not found $named");
      }
    } else {
      try {
        return _moduleConstructor._modules.singleWhere((element) => element.typeClass == T);
      } catch (e) {
        throw Exception("Module not found $T");
      }
    }
  }

  static T _getSingleton<T>(_Module module){
    if(module.singleton == null) {
      module.singleton = module.build();
    }
    return module.singleton;
  }

  static T _getBloc<T>(_Module module, bool shared){
    if(!shared || module.singleton == null){
      module.singleton = module.build();
    }
    return module.singleton;
  }

  static void destroyInstance(dynamic instance){
    var module = _moduleConstructor._modules.firstWhere((e) => e.singleton == instance);
    module.singleton = null;
  }

}

class _Module {

  final int type;
  final Build build;
  final String named;
  final Type typeClass;
  dynamic singleton;

  _Module(this.type, this.build, this.typeClass, {this.named});

}

class _ModuleConstructor {

  final List<_Module> _modules = [];

  void singleton<T>(Build<T> build, {String named}){
    _modules.add(_Module(1, build, T,
        named: named
    ));
  }

  void factory<T>(Build<T> build, {String named}){
    _modules.add(_Module(2, build, T,
        named: named
    ));
  }

  void bloc<T extends BaseBloc>(Build<T> build, {String named}){
    _modules.add(_Module(3, build, T,
        named: named
    ));
  }

}

typedef Build<T> = T Function();
typedef InjectionInitializer = Future<void> Function(_ModuleConstructor moduleConstructor);