import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_useful_things/base/BaseApp.dart';
import 'package:flutter_useful_things/base/BaseBloc.dart';
import 'package:flutter_useful_things/base/BaseScreen.dart';
import 'package:flutter_useful_things/components/containers/ResponseStreamBuilder.dart';
import 'package:flutter_useful_things/di/Injection.dart';
import 'package:flutter_useful_things/livedata/ResponseStream.dart';
import 'package:flutter_useful_things/routing/AppRoute.dart';
import 'package:flutter_useful_things/routing/AppNavigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BaseApp(
      title: 'Flutter Useful Things Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      injectionInitializer: (moduleConstructor) async {
        moduleConstructor.bloc(() => TesteBloc());
        log("Teste");
      },
      home: Menu(),
    );
  }
}

class Menu extends BaseScreen {
  @override
  String get name => "Menu";

  @override
  Widget buildScreen(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [FlatButton(onPressed: () async {
          await AppNavigator.pushReplacement(context, Teste());
        }, child: Text("Teste"))],
      ),
    );
  }
}

class Teste extends BaseScreen<TesteBloc> {

  @override
  String get name => "TESTE";

  @override
  TesteBloc bsBloc = bloc();

  @override
  void initState() {
    super.initState();
    bsBloc.testeee();
  }

  @override
  Widget buildScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        children: [
          FlatButton(onPressed: () async {
            await AppNavigator.pushReplacement(context, Menu());
          }, child: Text("Teste")),
          ResponseStreamBuilder(
            responseStream: bsBloc.stream,
            onData: (data) {
              return Text(data);
            },
            onEmpty: () {
              return Text("ESTA VAZIO");
            },
            onError: (error) {
              return Text("DEU ERRO :((((");
            },
            onLoading: () {
              return RefreshProgressIndicator();
            },
          )
        ],
      )
    );
  }

}

class TesteBloc extends BaseBloc {

  ResponseStream<String> stream;

  TesteBloc() {
    stream = ResponseStream(bloc: this);
  }

  void testeee() {
    stream.postLoad(
      action: () async {
        await Future.delayed(Duration(seconds: 2));
        var asd = [];
        return null;
      },
    );
  }

}