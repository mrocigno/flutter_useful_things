import 'package:flutter_useful_things/json/annotations/JsonMapperAnnotations.dart';

import '../Omg.dart';

part 'testeee.g.dart';

@Serialize
class User {

  int id;
  String name;
  String teste;
  bool favorite;
  Teste testeeee;

  @Ignore
  Omg omggggg;

}
