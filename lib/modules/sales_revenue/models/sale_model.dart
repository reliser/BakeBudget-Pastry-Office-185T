import 'package:hive/hive.dart';

part 'sale_model.g.dart';

@HiveType(typeId: 7)
class Sale {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double cost;

  @HiveField(3)
  final DateTime date;

  Sale({
    required this.category,
    required this.name,
    required this.cost,
    required this.date,
  });
}
