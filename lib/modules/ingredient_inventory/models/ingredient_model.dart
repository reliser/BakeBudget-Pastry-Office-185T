import 'package:hive/hive.dart';

part 'ingredient_model.g.dart'; 

@HiveType(typeId: 0) 
class Ingredient extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double cost;

  @HiveField(2)
  bool notificationEnabled;

  @HiveField(3)
  DateTime notificationDate;

  Ingredient({
    required this.name,
    required this.cost,
    required this.notificationEnabled,
    required this.notificationDate,
  });
}
