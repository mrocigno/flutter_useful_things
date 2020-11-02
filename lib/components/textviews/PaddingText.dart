/*
* Created to myfoodapp at 06/14/2020
*/
import "dart:developer" as dev;
import 'package:flutter/material.dart';
import 'package:flutter_useful_things/constants/Colors.dart' as Constants;

class PaddingText extends Text {

  final EdgeInsets padding;

  PaddingText(String data, {
    @required this.padding,
    style,
    textAlign,
    overflow,
    maxLines,
    key,
    locale,
    semanticsLabel,
    softWrap,
    strutStyle,
    textDirection,
    textHeightBehavior,
    textScaleFactor,
    textWidthBasis
  }) : super(
    data,
    style: style,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    key: key,
    locale: locale,
    semanticsLabel: semanticsLabel,
    softWrap: softWrap,
    strutStyle: strutStyle,
    textDirection: textDirection,
    textHeightBehavior: textHeightBehavior,
    textScaleFactor: textScaleFactor,
    textWidthBasis: textWidthBasis
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: super.build(context),
    );
  }
}
