import 'package:hive/hive.dart';

part 'equipment_model.g.dart';

@HiveType(typeId: 1)
class Equipment {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double cost;

  @HiveField(2)
  final bool notificationEnabled;

  @HiveField(3)
  final DateTime notificationDate;

  Equipment({
    required this.name,
    required this.cost,
    required this.notificationEnabled,
    required this.notificationDate,
  });
}
