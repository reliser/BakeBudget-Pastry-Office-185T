import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/models/sale_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class SalesCubitBakeBudget extends Cubit<List<Sale>> {
  SalesCubitBakeBudget() : super([]) {
    loadSales();
  }

  final Box<Sale> salesBox = Hive.box<Sale>('salesBox');

  void loadSales() {
    emit(salesBox.values.toList());
  }

  Future<void> addSale({
    required String category,
    required String name,
    required double cost,
  }) async {
    final sale = Sale(
      category: category,
      name: name,
      cost: cost,
      date: DateTime.now(),
    );
    await salesBox.add(sale);
    loadSales();
  }

  Future<void> updateSale(
    int index, {
    required String category,
    required String name,
    required double cost,
  }) async {
    final sale = Sale(
      category: category,
      name: name,
      cost: cost,
      date: DateTime.now(), 
    );
    await salesBox.putAt(index, sale);
    loadSales();
  }

  Future<void> deleteSale(int index) async {
    await salesBox.deleteAt(index);
    loadSales();
  }
}
