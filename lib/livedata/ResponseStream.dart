import 'dart:async';
import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_useful_things/base/BaseBloc.dart';
import 'package:flutter_useful_things/livedata/ErrorResponse.dart';
import 'package:rxdart/rxdart.dart';

class ResponseStream<T> {

  final BehaviorSubject<T> _data = BehaviorSubject();
  final BehaviorSubject<bool> _empty = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _loading = BehaviorSubject.seeded(false);
  final BehaviorSubject<ErrorResponse> _error = BehaviorSubject();

  ValueStream<T> get data => _data.stream;
  ValueStream<bool> get empty => _empty.stream;
  ValueStream<bool> get loading => _loading.stream;
  ValueStream<ErrorResponse> get error => _error.stream;

  bool get isClosed => _data.isClosed;
  Set<StreamSubscription> _subscriptions = {};

  ResponseStream({
    BaseBloc bloc
  }) {
    bloc?.registerStream(this);
  }

  Future<void> postLoad({
    @required Future<T> Function() action,
    bool cleanDataOnError = false
  }) async {
    try {
      _loading.add(true);

      var response = await action();
      if(isClosed) return;

      _error.add(null);
      if(response == null || (response is List && response.length <= 0)) {
        _empty.add(true);
        _data.add(null);
      } else {
        _empty.add(false);
        _data.add(response);
      }
    } on DioError catch(exception, stacktrace) {
      dev.log("Dio error inside $T");
      dev.log("$exception \n $stacktrace");
      _error.value = ErrorResponse(
        code: exception.response.statusCode,
        message: exception.response.statusMessage,
        data: exception.response.data
      );
      if (cleanDataOnError) _data.add(null);
    } catch (exception, stacktrace) {
      dev.log("Error inside postLoad $T");
      dev.log("$exception \n $stacktrace");
      _error.value = ErrorResponse(
        code: 0,
        message: exception.toString(),
        data: exception
      );
      if (cleanDataOnError) _data.add(null);
     } finally {
      if(!isClosed){
        _loading.add(false);
      }
    }
  }

  void close() {
    _data.close();
    _loading.close();
    _error.close();
    _empty.close();
    _subscriptions.removeWhere((element) {
      element.cancel();
      return true;
    });
    _subscriptions = null;
  }

  T getSyncValue() {
    return _data.value;
  }
}