import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_useful_things/di/Injection.dart';
import 'package:flutter_useful_things/livedata/ResponseStream.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {

  Set<ResponseStream> _streamControllers = {};

  void close() {
    Injection.destroyInstance(this);
    _streamControllers.removeWhere((element) {
      element.close();
      return true;
    });
  }

  void registerStream(ResponseStream responseStream) {
    _streamControllers.add(responseStream);
  }

}