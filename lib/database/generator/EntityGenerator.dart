
import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_useful_things/database/base/Entity.dart';
import 'package:flutter_useful_things/database/build.dart';
import 'package:flutter_useful_things/database/tamplate/EntityTemplate.dart';
import 'package:source_gen/source_gen.dart';

class EntityGenerator extends Generator {

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    var classes = convertImpl(library);
    String result = "";
    classes.forEach((element) {
      result += '''
        $element
      ''';
    });
    return result;
  }

  Iterable<EntityTemplate> convertImpl(LibraryReader library) sync* {
    for (final classElement in library.classes) {
      if (isMixinStoreClass(classElement)) {
        yield EntityTemplate(classElement);
      }
    }
  }

  final _storeMixinChecker = TypeChecker.fromRuntime(Entity);

  bool isMixinStoreClass(ClassElement classElement) =>
      classElement.mixins.any(_storeMixinChecker.isExactlyType);
}