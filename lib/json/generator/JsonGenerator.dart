
import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_useful_things/json/annotations/JsonMapperAnnotations.dart';
import 'package:flutter_useful_things/json/tamplate/JsonTemplate.dart';
import 'package:source_gen/source_gen.dart';

class JsonGenerator extends GeneratorForAnnotation<JsonSerialize> {

  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is ClassElement) {
      return JsonTemplate(element).toString();
    }
    return "";
  }
}