
import 'package:build/build.dart';
import 'package:flutter_useful_things/json/generator/JsonGenerator.dart';
import 'package:source_gen/source_gen.dart';

Builder jsonGenerator(BuilderOptions options) =>
    SharedPartBuilder([JsonGenerator()], "json");
