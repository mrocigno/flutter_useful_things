import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_useful_things/livedata/ErrorResponse.dart';
import 'package:flutter_useful_things/livedata/MutableResponseStream.dart';
import 'package:rxdart/rxdart.dart';

class ResponseStream<T> {

  final MutableResponseStream _mutable;

  ValueStream<T> get success => _mutable.data.stream;
  ValueStream<bool> get empty => _mutable.empty.stream;
  ValueStream<bool> get loading => _mutable.loading.stream;
  ValueStream<dynamic> get error => _mutable.error.stream;

  ResponseStream(this._mutable);

  void observeLoading(void onLoading(bool loading)) => loading.listen(onLoading);
  void observeEmpty(void onEmpty(bool empty)) => empty.listen(onEmpty);
  void observeSuccess(void onSuccess(T data)) => success.listen(onSuccess);
  void observeError(void onError(dynamic error)) => error.listen((listened) {
    if (listened == null) return;
    onError(listened);
  });

  void observe({
    void onSuccess(T data),
    void onLoading(bool loading),
    void onError(dynamic error)
  }) {
    if(onSuccess != null) observeSuccess(onSuccess);
    if(onLoading != null) observeLoading(onLoading);
    if(onError != null) observeError(onError);
  }

  void close() => _mutable.close();

  T getSyncValue() => _mutable.getSyncValue();

}