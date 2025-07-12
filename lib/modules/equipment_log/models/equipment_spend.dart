import 'package:hive/hive.dart';

part 'equipment_spend.g.dart';

@HiveType(typeId: 6)
class EquipmentSpend {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String equipmentName;

  EquipmentSpend({
    required this.amount,
    required this.date,
    required this.equipmentName,
  });
}
