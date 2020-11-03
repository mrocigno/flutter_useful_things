
import 'dart:typed_data';

import 'package:analyzer/dart/element/element.dart';
import 'package:flutter_useful_things/database/base/Annotations.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutter_useful_things/utils/IterableUtils.dart';

class EntityTemplate {

  final ClassElement classElement;
  final _aiChecker = TypeChecker.fromRuntime(EntityAutoIncrement);
  final _idChecker = TypeChecker.fromRuntime(EntityPrimaryKey);
  final _fieldChecker = TypeChecker.fromRuntime(Field);

  final _numChecker = TypeChecker.fromRuntime(num);
  final _intChecker = TypeChecker.fromRuntime(int);
  final _doubleChecker = TypeChecker.fromRuntime(double);
  final _boolChecker = TypeChecker.fromRuntime(bool);
  final _blobChecker = TypeChecker.fromRuntime(Uint8List);

  EntityTemplate(this.classElement);

  String get className => "${classElement.name}Impl";

  String get primaryKey {
    for(var field in classElement.fields) {
      if (isPrimaryKey(field)) return field.name;
    }
    throw Exception("Declare the primaryKey");
  }

  String get constructor {
    List<String> values = [];
    for(var field in classElement.fields) {
      var value = _getFieldName(field);
      values.add("this.$value,");
    }
    return values.join("\n");
  }

  String get toMap {
    List<String> values = [];
    for(var field in classElement.fields) {
      var value = _getFieldName(field);
      values.add("\"$value\": ${field.name},");
    }
    return values.join("\n");
  }

  String get fromMap {
    List<String> values = [];
    for(var field in classElement.fields) {
      var value = _getFieldName(field);
      values.add("this.${field.name} = map[\"$value\"];");
    }
    return values.join("\n");
  }

  String get creationSql {
    StringBuffer sbFields = StringBuffer("");
    for(var field in classElement.fields) {
      var fieldName = _getFieldName(field);
      var fieldType = _getFieldType(field);
      var autoIncrement = isAutoIncremental(field)? " AUTOINCREMENT" : "";
      var primaryKey = isPrimaryKey(field)? " PRIMARY KEY" : "";
      sbFields.write("$fieldName $fieldType$primaryKey$autoIncrement   ");
    }
    var fields = sbFields.toString().trim().replaceAll("   ", ", ");
    return "CREATE TABLE ${classElement.name} ($fields)";
  }

  String _getFieldName(FieldElement field) {
    var fieldAnnotation = _fieldChecker.firstAnnotationOfExact(field);
    String value;
    if (fieldAnnotation != null) {
      value = fieldAnnotation.getField("name").toStringValue();
      if (value.isEmpty) throw Exception("Field name cannot be null/empty");
    } else {
      value = field.name;
    }
    return value;
  }

  String _getFieldType(FieldElement field) {
    var type = "TEXT";
    if (isInt(field) || isBool(field)) {
      type = "INTEGER";
    } else if (isNum(field) || isDouble(field)) {
      type = "REAL";
    } else if (isBlob(field)) {
      type = "BLOB";
    }
    return type;
  }

  bool isAutoIncremental(FieldElement field) => _aiChecker.hasAnnotationOfExact(field);
  bool isPrimaryKey(FieldElement field) => _idChecker.hasAnnotationOfExact(field);

  bool isNum(FieldElement field) => _numChecker.isExactlyType(field.type);
  bool isInt(FieldElement field) => _intChecker.isExactlyType(field.type);
  bool isDouble(FieldElement field) => _doubleChecker.isExactlyType(field.type);
  bool isBool(FieldElement field) => _boolChecker.isExactlyType(field.type);
  bool isBlob(FieldElement field) => _blobChecker.isExactlyType(field.type);

  @override
  String toString() {
    return '''
    class $className extends ${classElement.name} {
      
      $className.fromMap(Map<String, dynamic> map) {
        $fromMap
      }
      
      @override
      Map<String, dynamic> toMap() => {
        $toMap
      };
      
      @override
      String getPrimaryKey() => $primaryKey.toString();
      
      @override
      String creationSql() => \"$creationSql\";
      
    }
    ''';
  }
}