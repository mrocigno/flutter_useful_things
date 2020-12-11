import 'dart:async';
import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:flutter_useful_things/livedata/ErrorResponse.dart';
import 'package:flutter_useful_things/livedata/ResponseStream.dart';
import 'package:rxdart/rxdart.dart';

class MutableResponseStream<T> {

  final BehaviorSubject<T> data;
  final BehaviorSubject<bool> empty = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> loading = BehaviorSubject.seeded(false);
  final BehaviorSubject<dynamic> error = BehaviorSubject();
  ResponseStream<T> get observable => ResponseStream(this);

  final T seedValue;
  bool get isClosed => data.isClosed;

  MutableResponseStream({this.seedValue}) : data = BehaviorSubject();

  Future<void> postLoad(
    Future<T> execute(),
    {
      void onSuccess(T data),
      void onLoading(bool loading),
      void onError(ErrorResponse data)
    }
  ) async {
    try {
      loading.add(true);
      onLoading?.call(true);

      var response = await execute();
      if(isClosed) return;

      error.add(null);
      if(response == null || (response is List && response.length <= 0)) {
        empty.add(true);
        data.add(null);
      } else {
        empty.add(false);
        data.add(response);
      }
      onSuccess?.call(response);

    } catch (exception, stacktrace) {
      dev.log("Error inside postLoad $T");
      dev.log("$exception \n $stacktrace");
      var errorResponse = (exception is DioError? (
        ErrorResponse(
          code: exception.response.statusCode,
          message: exception.response.statusMessage,
          data: exception.response.data
        )
      ) : exception );
      error.add(errorResponse);
      onError?.call(exception);
    } finally {
      if(!isClosed){
        loading.add(false);
        onLoading?.call(false);
      }
    }
  }

  void addData(T data){
    this.data.add(data);
  }

  void addError(dynamic error) {
    this.error.add(error);
  }

  void setLoading(bool loading) {
    this.loading.add(loading);
  }

  void close() {
    data.close();
    loading.close();
    error.close();
    empty.close();
  }

  T getSyncValue() {
    return data.value;
  }
}