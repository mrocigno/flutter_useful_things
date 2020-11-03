


import 'package:flutter_useful_things/database/base/Annotations.dart';
import 'package:flutter_useful_things/database/base/Entity.dart';

part 'testeee.g.dart';

abstract class User with Entity {

  @PrimaryKey
  @AutoIncrement
  @Field("seupaidecalcinha")
  int id;

  @Field("roberto")
  String name;

  String teste;

}