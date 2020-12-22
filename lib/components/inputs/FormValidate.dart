import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:flutter_useful_things/components/inputs/InputText.dart';

class FormValidate extends StatefulWidget {
  FormValidate({
    Key key,
    this.child,
    this.padding,
    this.decoration
  }) : super(key: key);

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Decoration decoration;

  @override
  FormValidateState createState() => FormValidateState();

}

class FormValidateState extends State<FormValidate> {

  Set<EditTextState> _inputs = Set();
  static void registerForValidate(BuildContext context, EditTextState input) {
    _FormValidateScope state = context.dependOnInheritedWidgetOfExactType<_FormValidateScope>();
    state?.state?._register(input);
  }

  void _register(EditTextState input){
    _inputs.add(input);
  }

  @override
  Widget build(BuildContext context) {
    return _FormValidateScope(
      state: this,
      child: Container(
        decoration: widget.decoration,
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }

  bool validate() {
    bool error = false;
    for (EditTextState child in _inputs){
      if(!(child.widget.controller?.validate() ?? true)){
        error = true;
      }
    }
    return !error;
  }

}

class _FormValidateScope extends InheritedWidget {
  _FormValidateScope({
    key,
    child,
    this.state
  }) : super(key: key, child: child);

  final FormValidateState state;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}