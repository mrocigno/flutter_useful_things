
import 'dart:async';
import 'dart:developer' as dev;

import 'package:build/build.dart';
import 'package:flutter_useful_things/database/base/Annotations.dart';
import 'package:flutter_useful_things/database/base/Entity.dart';
import 'package:flutter_useful_things/database/generator/EntityGenerator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

Builder entityGenerator(BuilderOptions options) =>
    SharedPartBuilder([EntityGenerator()], "entity");