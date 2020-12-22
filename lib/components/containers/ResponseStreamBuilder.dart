import 'package:flutter/material.dart';
import 'package:flutter_useful_things/livedata/ErrorResponse.dart';
import 'package:flutter_useful_things/livedata/ResponseStream.dart';

typedef OnLoading = Widget Function();
typedef OnEmpty = Widget Function();
typedef OnError = Widget Function(ErrorResponse error);
typedef OnData<T> = Widget Function(T data);

class ResponseStreamBuilder<T> extends StatelessWidget {

  final ResponseStream<T> responseStream;

  final OnLoading onLoading;
  final OnData<T> onData;
  final OnEmpty onEmpty;
  final OnError onError;

  const ResponseStreamBuilder({
    Key key,
    this.responseStream,
    this.onLoading,
    this.onData,
    this.onEmpty,
    this.onError
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    if (onData != null) {
      children.add(StreamBuilder<T>(
        stream: responseStream.data,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Wrap();
          return onData(snapshot.data);
        },
      ));
    }
    if (onLoading != null) {
      children.add(StreamBuilder<bool>(
        stream: responseStream.loading,
        initialData: false,
        builder: (context, snapshot) {
          if (!snapshot.data) return Wrap();
          return onLoading();
        },
      ));
    }
    if (onEmpty != null) {
      children.add(StreamBuilder<bool>(
        stream: responseStream.empty,
        initialData: false,
        builder: (context, snapshot) {
          if (!snapshot.data) return Wrap();
          return onEmpty();
        },
      ));
    }
    if (onError != null) {
      children.add(StreamBuilder<ErrorResponse>(
        stream: responseStream.error,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Wrap();
          return onError(snapshot.data);
        },
      ));
    }

    return Stack(
      children: children,
    );
  }
}
