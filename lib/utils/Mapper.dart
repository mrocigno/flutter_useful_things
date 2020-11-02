abstract class Mapper<Entity> {

  Map<String, dynamic> toDataMap(Entity input);

  Entity fromDataMap(Map<String, dynamic> input);

}