abstract class Entity {
  String getPrimaryKey();
  Map<String, dynamic> toMap();
  String creationSql();
}