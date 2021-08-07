
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

typedef ValidateEvent = bool Function(String text);
typedef InputValidateBuild = void Function(_ValidateWrapper wrapper);

class InputController extends TextEditingController{

  InputController({
    this.validateBuild,
    this.mask,
    String text
  }) : super(text: text) {
    if (validateBuild != null) {
      _validateWrapper = _ValidateWrapper(this);
      validateBuild(_validateWrapper);
    }
  }

  _ValidateWrapper _validateWrapper;
  BehaviorSubject<String> _errorMsg = BehaviorSubject();
  BehaviorSubject<String> _iconPath = BehaviorSubject();

  Stream getErrorStream() => _errorMsg;
  Stream getIconStream() => _iconPath;

  String mask;

  setError(String msg){
    _errorMsg.add(msg);
    hasError = msg != null;
  }

  setIcon(String path){
    _iconPath.add(path);
    hasIcon = path != null;
  }

  bool hasError = false;
  bool hasIcon = false;
  InputValidateBuild validateBuild;

  bool validate(){
    bool result = _validateWrapper?.validate() ?? true;
    if(result) setError(null);
    return result;
  }

  void configureForMask() {
    this.addListener(() {
      this.selection = TextSelection.collapsed(offset: this.text?.length);
    });
  }

  int maskCompensation = 0;
  int oldLength = 0;
  void handleMask() {
    if (mask == null) return;
    maskCompensation = 0;
    List<String> textList = unmasked.split('');
    List<String> maskList = mask.split('');

    bool erasing = unmasked.length < oldLength;
    oldLength = unmasked.length;

    if (erasing) return;

    var newText = "";
    for(int i = 0; i < unmasked.length; i++){
      var textChar = textList[i];
      if(i < maskList.length) {
        var maskChar = maskList[i + maskCompensation];
        newText += _getChar(textChar, maskChar, maskList);
      }
    }

    text = newText;
    selection = TextSelection.collapsed(offset: newText.length, affinity: TextAffinity.upstream);
  }

  String _getChar(String textChar, String maskChar, List<String> maskList) {
    if (maskChar == "#") {
      return (textChar.isNumeric? textChar : "");
    } else {
      if (textChar.isNumeric) {
        maskCompensation++;
        return "$maskChar${_getChar(textChar, maskList[maskList.indexOf(maskChar) + 1], maskList)}";
      }
    }
    return "";
  }

  @override
  set text(String newText) {
    var addMask = text != newText;
    super.text = newText;
    if (addMask) handleMask();
    setError(null);
  }

  String get unmasked => text.replaceAll(RegExp("\\D"), "");

  bool isEmpty() => text.length == 0;

  @override
  void dispose() {
    super.dispose();
    _errorMsg.close();
  }
}

extension StringExt on String {

  bool get isNumeric => RegExp("\\d").hasMatch(this);
}

class _ValidateWrapper {
  _ValidateWrapper(this.controller);

  final InputController controller;
  final List<_Event> events = List();

  void required(String message){
    events.add(_Event(message, (text) => text.length > 0));
  }

  void minLength(int minLength, String message){
    events.add(_Event(message, (text) => text.length >= minLength));
  }

  void customValidate(String message, ValidateEvent event){
    events.add(_Event(message, event));
  }

  void isEmail(String message){
    events.add(_Event(message, (text) {
      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      return regExp.hasMatch(text);
    }));
  }

  void isCpf(String message) {
    events.add(_Event(message, (text) {
      return _cpfValidation(text);
    }));
  }

  void twoOrMore(String message) {
    events.add(_Event(message, (text) {
      List<String> list = text.trim().split(" ");
      return list.length > 1;
    }));
  }

  void isCreditCard(String message) {
    events.add(_Event(message, (text) {
      var sum = 0, i = 0;
      text = text.replaceAll(RegExp(r'\D'), "");
      text.split('').reversed.forEach((e) {
        int digit = int.parse(e);
        if(i++ % 2 == 1) digit *= 2;
        sum += digit > 9? (digit - 9) : digit;
      });
      return sum % 10 == 0;
    }));
  }

  void isBrCellphone(String message) {
    events.add(_Event(message, (text) {
      return RegExp(r'\([0-9]{2}\) 9[0-9]{4}-[0-9]{4}').hasMatch(text);
    }));
  }

  void hasUppercaseChar(String message) {
    events.add(_Event(message, (text) {
      return RegExp(r'.*[A-Z]').hasMatch(text);
    }));
  }

  void hasNumberChar(String message) {
    events.add(_Event(message, (text) {
      return RegExp(r'.*[\d]').hasMatch(text);
    }));
  }

  void hasEspecialChar(String message) {
    events.add(_Event(message, (text) {
      return RegExp(r'.*[@$!%*?&]').hasMatch(text);
    }));
  }

  bool validate(){
    if(events.length == 0){
      return true;
    }
    bool result = true;
    for (_Event event in events) {
      if(!event.event(controller.text.trim())){
        result = false;
        controller.setError(event.message);
      }
    }
    return result;
  }

  bool _cpfValidation(String cpf) {
    if (cpf == null) return false;
    var treated = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (treated.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(treated)) return false;
    List<int> digits = treated.split('').map((String d) => int.parse(d)).toList();
    var dg1 = 0;
    for (var i in Iterable<int>.generate(9, (i) => 10 - i)) {
      dg1 += digits[10 - i] * i;
    }
    dg1 %= 11;
    var dv1 = dg1 < 2 ? 0 : 11 - dg1;
    if (digits[9] != dv1) return false;
    var dg2 = 0;
    for (var i in Iterable<int>.generate(10, (i) => 11 - i)) {
      dg2 += digits[11 - i] * i;
    }
    dg2 %= 11;
    var dv2 = dg2 < 2 ? 0 : 11 - dg2;
    if (digits[10] != dv2) return false;

    return true;
  }
}

class _Event {
  _Event(this.message, this.event);

  final String message;
  final ValidateEvent event;
}