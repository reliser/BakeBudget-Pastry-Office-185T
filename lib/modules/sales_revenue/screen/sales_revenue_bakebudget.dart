import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/widgets/showDatePicker_bakebudget.dart';
import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/cubits/sales_cubit_bakebudget.dart';
import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/screen/sales_edit_bakebudget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/models/sale_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/screen/sales_add_bakebudget.dart';

class SalesRevenueBakeBudget extends StatefulWidget {
  const SalesRevenueBakeBudget({super.key});

  @override
  State<SalesRevenueBakeBudget> createState() => _SalesRevenueBakeBudgetState();
}

class _SalesRevenueBakeBudgetState extends State<SalesRevenueBakeBudget> {
  DateTime selectedDate = DateTime.now();

  List<Sale> filterSalesByMonth(List<Sale> sales, DateTime date) {
    return sales.where((sale) {
      return sale.date.year == date.year && sale.date.month == date.month;
    }).toList();
  }

  double computeTotalRevenue(List<Sale> sales) {
    return sales.fold(0.0, (sum, sale) => sum + sale.cost);
  }

  Map<DateTime, List<Sale>> groupSalesByDay(List<Sale> sales) {
    Map<DateTime, List<Sale>> grouped = {};
    for (var sale in sales) {
      final day = DateTime(sale.date.year, sale.date.month, sale.date.day);
      if (grouped[day] == null) {
        grouped[day] = [];
      }
      grouped[day]!.add(sale);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    Map<DateTime, List<Sale>> sortedGrouped = {};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }
    return sortedGrouped;
  }

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat.MMMM().format(selectedDate);
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          'Sales & Revenue',
          style: TextStyle(
            fontSize: 28.sp,
            color: const Color(0xFFFAFAFA),
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<SalesCubitBakeBudget, List<Sale>>(
        builder: (context, sales) {
          final filteredSales = filterSalesByMonth(sales, selectedDate);
          final totalRevenue = computeTotalRevenue(filteredSales);
          final groupedSales = groupSalesByDay(filteredSales);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 10.h),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 239.w,
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF343434),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$monthName:',
                                style: const TextStyle(
                                  color: Color(0xFF1DACD6),
                                  fontSize: 12,
                                  fontFamily: 'SF Compact Rounded',
                                  fontWeight: FontWeight.w400,
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              const Text(
                                'sales for the month',
                                style: TextStyle(
                                  color: Color(0xFFFAFAFA),
                                  fontSize: 12,
                                  fontFamily: 'SF Compact Rounded',
                                  fontWeight: FontWeight.w400,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$ ${totalRevenue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFF1DACD6),
                              fontSize: 12,
                              fontFamily: 'SF Compact Rounded',
                              fontWeight: FontWeight.w400,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        showDatePickerDialogBakeBudget(context, selectedDate, (
                          DateTime newDate,
                        ) {
                          setState(() {
                            selectedDate = newDate;
                          });
                        });
                      },
                      child: Container(
                        width: 60.w,
                        height: 48.h,
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF1DACD6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Select',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFAFAFA),
                            fontSize: 12,
                            fontFamily: 'SF Compact Rounded',
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (filteredSales.isEmpty)
                  if (selectedDate.year == DateTime.now().year &&
                      selectedDate.month == DateTime.now().month)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.asset(
                        'assets/images/sales.png',
                        width: double.infinity,
                        height: 404,
                        fit: BoxFit.contain,
                      ),
                    )
                  else if (selectedDate.isBefore(DateTime.now()))
                    Container(
                      width: 311.w,
                      margin: EdgeInsets.only(top: 36.h),
                      padding: EdgeInsets.all(16.r),
                      decoration: ShapeDecoration(
                        color: Color(0xFF343434),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'You have no statistics for this period. ',
                              style: TextStyle(
                                color: Color(0xFF1DACD6),
                                fontSize: 16,
                                fontFamily: 'SF Compact Rounded',
                                fontWeight: FontWeight.w400,
                                height: 1.25,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  'Select another month in which you kept records of items sold.',
                              style: TextStyle(
                                color: Color(0x99FAFAFA),
                                fontSize: 16,
                                fontFamily: 'SF Compact Rounded',
                                fontWeight: FontWeight.w400,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  else
                    Container(
                      width: 311.w,
                      margin: EdgeInsets.only(top: 36.h),
                      padding: EdgeInsets.all(16.r),
                      decoration: ShapeDecoration(
                        color: Color(0xFF343434),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  'This month has not yet arrived and therefore there are no statistics here. ',
                              style: TextStyle(
                                color: Color(0xFF1DACD6),
                                fontSize: 16,
                                fontFamily: 'SF Compact Rounded',
                                fontWeight: FontWeight.w400,
                                height: 1.25,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  'Select the month in which you kept records of the items sold.',
                              style: TextStyle(
                                color: Color(0x99FAFAFA),
                                fontSize: 16,
                                fontFamily: 'SF Compact Rounded',
                                fontWeight: FontWeight.w400,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                else
                  ListView.separated(
                    padding: EdgeInsets.only(top: 22.h),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder:
                        (context, index) => SizedBox(height: 20.h),
                    itemCount: groupedSales.keys.length,
                    itemBuilder: (context, index) {
                      final dateKey = groupedSales.keys.toList()[index];
                      final salesForDay = groupedSales[dateKey]!;
                      final formattedDate = DateFormat.yMMMMd().format(dateKey);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Color(0xFF1DACD6),
                              fontSize: 14,
                              fontFamily: 'SF Compact Rounded',
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: salesForDay.length,
                            separatorBuilder:
                                (context, i) => SizedBox(height: 10.h),
                            itemBuilder: (context, i) {
                              final sale = salesForDay[i];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EditSalesBakeBudget(
                                            sale: sale,
                                            saleIndex: i,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.r),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF343434),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        "assets/images/sales_revenue.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sale.name,
                                        style: const TextStyle(
                                          color: Color(0xFF1DACD6),
                                          fontSize: 20,
                                          fontFamily: 'SF Compact Rounded',
                                          fontWeight: FontWeight.w500,
                                          height: 1.25,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Opacity(
                                            opacity: 0.40,
                                            child: const Text(
                                              'Category:',
                                              style: TextStyle(
                                                color: Color(0xFFFAFAFA),
                                                fontSize: 14,
                                                fontFamily:
                                                    'SF Compact Rounded',
                                                fontWeight: FontWeight.w400,
                                                height: 1.40,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            sale.category,
                                            style: const TextStyle(
                                              color: Color(0xFFFAFAFA),
                                              fontSize: 14,
                                              fontFamily: 'SF Compact Rounded',
                                              fontWeight: FontWeight.w400,
                                              height: 1.40,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Opacity(
                                            opacity: 0.40,
                                            child: const Text(
                                              'Cost:',
                                              style: TextStyle(
                                                color: Color(0xFFFAFAFA),
                                                fontSize: 14,
                                                fontFamily:
                                                    'SF Compact Rounded',
                                                fontWeight: FontWeight.w400,
                                                height: 1.40,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '\$ ${sale.cost.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Color(0xFFFAFAFA),
                                              fontSize: 14,
                                              fontFamily: 'SF Compact Rounded',
                                              fontWeight: FontWeight.w400,
                                              height: 1.40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSalesBakeBudget()),
          );
        },
        child: Container(
          width: 311.w,
          height: 48.h,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: const Color(0xFF1DACD6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Add',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFAFAFA),
              fontSize: 16,
              fontFamily: 'SF Compact Rounded',
              fontWeight: FontWeight.w400,
              height: 1.25,
            ),
          ),
        ),
      ),
    );
  }
}
