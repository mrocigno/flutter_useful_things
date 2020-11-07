import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:flutter_useful_things/json/annotations/JsonMapperAnnotations.dart';
import 'package:source_gen/source_gen.dart';

final _stringChecker = TypeChecker.fromRuntime(String);
final _doubleChecker = TypeChecker.fromRuntime(double);
final _boolChecker = TypeChecker.fromRuntime(bool);
final _numChecker = TypeChecker.fromRuntime(num);
final _intChecker = TypeChecker.fromRuntime(int);

final _serializeChecker = TypeChecker.fromRuntime(JsonSerialize);
final _ignoreChecker = TypeChecker.fromRuntime(JsonIgnore);
final _fieldChecker = TypeChecker.fromRuntime(JsonField);

class JsonTemplate {

  final ClassElement classElement;

  JsonTemplate(this.classElement);

  String get className => classElement.name;

  String get toJson {
    List<String> values = [];
    for(var field in classElement.fields) {
      if (!field.isIgnorable) values.add(_getToJsonValue(field));
    }
    return values.join("\n");
  }

  String get fromJson {
    List<String> values = [];
    for(var field in classElement.fields) {
      if (!field.isIgnorable) values.add(_getFromJsonValue(field));
    }
    return values.join("\n");
  }

  @override
  String toString() {
    return '''
      extension ${className}Ext on $className {
        
        void fromJson(Map<String, dynamic> map) {
          $fromJson
        }
        
        Map<String, dynamic> toJson() => {
          $toJson
        };
      }
    ''';
  }

  String _getFieldName(FieldElement field) {
    var fieldAnnotation = field.fieldAnnotation;
    if (fieldAnnotation != null) {
      return fieldAnnotation.getField("name").toStringValue();
    } else {
      return field.name;
    }
  }

  String _getToJsonValue(FieldElement field) {
    var value = _getFieldName(field);
    if (field.isPrimitiveType) {
      return '\"$value\": ${field.name},';
    } else {
      if (field.isSerialize) {
        return '\"$value\": ${field.name}.toJson(),';
      } else {
        return '\"$value\": ${field.name}.toString(),';
      }
    }
  }

  String _getFromJsonValue(FieldElement field) {
    var value = _getFieldName(field);
    if (field.isPrimitiveType) {
      return 'this.${field.name} = map["$value"];';
    } else {
      if (field.isSerialize) {
        return 'this.${field.name} = ${field.typeAsString}()..fromJson(map["$value"]);';
      } else {
        return 'this.${field.name} = null;';
      }
    }
  }
}

extension FieldElementExt on FieldElement {

  String get typeAsString => type.getDisplayString(withNullability: false);

  DartObject get fieldAnnotation => _fieldChecker.firstAnnotationOfExact(this);

  bool get isSerialize => _serializeChecker.hasAnnotationOfExact(this.type.element);

  bool get isIgnorable => _ignoreChecker.hasAnnotationOfExact(this);

  bool get isPrimitiveType =>
      _doubleChecker.isExactlyType(type) ||
      _stringChecker.isExactlyType(type) ||
      _boolChecker.isExactlyType(type) ||
      _intChecker.isExactlyType(type) ||
      _numChecker.isExactlyType(type);

}