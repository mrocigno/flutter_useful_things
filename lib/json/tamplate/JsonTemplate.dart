import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:flutter_useful_things/json/annotations/JsonMapperAnnotations.dart';
import 'package:source_gen/source_gen.dart';

final _stringChecker = TypeChecker.fromRuntime(String);
final _doubleChecker = TypeChecker.fromRuntime(double);
final _boolChecker = TypeChecker.fromRuntime(bool);
final _numChecker = TypeChecker.fromRuntime(num);
final _intChecker = TypeChecker.fromRuntime(int);
final _listChecker = TypeChecker.fromRuntime(List);

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
      return '\"$value\": this.${field.name},';
    } else {
      if (field.isSerialize) {
        return '\"$value\": this.${field.name}.toJson(),';
      } else {
        if (field.isList) {
          var type = field.type;
          if (type is ParameterizedType) {
            var arg = type.typeArguments[0];
            if (arg.isPrimitiveType) {
              return '"$value": this.${field.name},';
            } else if (arg.isSerialize) {
              return '''
                "$value": (this.${field.name} != null? (
                  this.${field.name}.map((v) => v.toJson()).toList()
                ) : null),
              ''';
            }
          }
        }
      }
    }
    return '\"$value\": ${field.name}.toString(),';
  }

  String _getFromJsonValue(FieldElement field) {
    var value = _getFieldName(field);
    if (field.isPrimitiveType) {
      return 'this.${field.name} = map["$value"];';
    } else {
      if (field.isSerialize) {
        return 'this.${field.name} = ${field.typeAsString}()..fromJson(map["$value"]);';
      } else if (field.isList) {
        var type = field.type;
        if (type is ParameterizedType) {
          var arg = type.typeArguments[0];
          if (arg.isPrimitiveType) {
            return 'this.${field.name} = map["$value"].cast<${arg.typeAsString}>();';
          } else if (arg.isSerialize) {
            return '''
            if (map["$value"] != null) {
              this.${field.name} = <${arg.typeAsString}>[]; 
              map["$value"].forEach((v) {
                this.${field.name}.add(${arg.typeAsString}()..fromJson(v));
              });
            }
            ''';
          }
        }
      }
    }
    return 'this.${field.name} = null;';
  }
}

extension FieldElementExt on FieldElement {

  String get typeAsString => type.getDisplayString(withNullability: false);

  DartObject get fieldAnnotation => _fieldChecker.firstAnnotationOfExact(this);

  bool get isSerialize => _serializeChecker.hasAnnotationOfExact(this.type.element);

  bool get isIgnorable => _ignoreChecker.hasAnnotationOfExact(this);

  bool get isList => _listChecker.isExactlyType(type);

  bool get isPrimitiveType =>
      _doubleChecker.isExactlyType(type) ||
      _stringChecker.isExactlyType(type) ||
      _boolChecker.isExactlyType(type) ||
      _intChecker.isExactlyType(type) ||
      _numChecker.isExactlyType(type);

}

extension DartTypeExt on DartType {

  String get typeAsString => getDisplayString(withNullability: false);

  bool get isSerialize => _serializeChecker.hasAnnotationOfExact(element);

  bool get isPrimitiveType =>
      _doubleChecker.isExactlyType(this) ||
      _stringChecker.isExactlyType(this) ||
      _boolChecker.isExactlyType(this) ||
      _intChecker.isExactlyType(this) ||
      _numChecker.isExactlyType(this);

}