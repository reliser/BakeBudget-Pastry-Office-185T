import 'package:bakebudget_pastry_office_185t/modules/onboarding/preium_bakebudget.dart';
import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/cubits/sales_cubit_bakebudget.dart';
import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/models/sale_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../bakebudget_prem.dart';

class AnalyticsBakeBudget extends StatefulWidget {
  const AnalyticsBakeBudget({super.key});

  @override
  State<AnalyticsBakeBudget> createState() => _AnalyticsBakeBudgetState();
}

class _AnalyticsBakeBudgetState extends State<AnalyticsBakeBudget> {
  DateTime selectedDate = DateTime.now();

  List<Sale> filterSalesByMonth(List<Sale> sales, DateTime date) {
    return sales.where((sale) {
      return sale.date.year == date.year && sale.date.month == date.month;
    }).toList();
  }

  double computeTotalSales(List<Sale> sales) {
    return sales.fold(0.0, (sum, sale) => sum + sale.cost);
  }

  Map<String, double> sumByCategory(List<Sale> sales) {
    final Map<String, double> result = {};
    for (var sale in sales) {
      result[sale.category] = (result[sale.category] ?? 0) + sale.cost;
    }
    return result;
  }

  void _goToPreviousMonth() {
    final prevMonth = DateTime(selectedDate.year, selectedDate.month - 1, 1);
    setState(() {
      selectedDate = prevMonth;
    });
  }

  void _goToNextMonth() {
    final nextMonth = DateTime(selectedDate.year, selectedDate.month + 1, 1);
    setState(() {
      selectedDate = nextMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          'Analytics',
          style: TextStyle(
            fontSize: 28.sp,
            color: const Color(0xFFFAFAFA),
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BlocBuilder<SalesCubitBakeBudget, List<Sale>>(
        builder: (context, allSales) {
          if (allSales.isEmpty) {
            return _buildEmptyAnalytics();
          }

          final filteredSales = filterSalesByMonth(allSales, selectedDate);
          final totalSales = computeTotalSales(filteredSales);

          return _buildAnalyticsContent(filteredSales, totalSales);
        },
      ),
    );
  }

  Widget _buildEmptyAnalytics() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      child: Column(
        children: [
          Container(
            width: 311.w,
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: ShapeDecoration(
              color: const Color(0xFF343434),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: 0.60,
                  child: Text(
                    'Current month profit:',
                    style: TextStyle(
                      color: const Color(0xFFFAFAFA),
                      fontSize: 14.sp,
                      fontFamily: 'SF Compact Rounded',
                      fontWeight: FontWeight.w400,
                      height: 1.40,
                    ),
                  ),
                ),
                Text(
                  '-',
                  style: TextStyle(
                    color: const Color(0xFFFAFAFA),
                    fontSize: 14.sp,
                    fontFamily: 'SF Compact Rounded',
                    fontWeight: FontWeight.w400,
                    height: 1.40,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Opacity(
                    opacity: 0.40,
                    child: Text(
                      'Income, %:',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 12.sp,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '-',
                    style: TextStyle(
                      color: const Color(0xFF7CB342),
                      fontSize: 12.sp,
                      fontFamily: 'SF Compact Rounded',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Opacity(
                    opacity: 0.40,
                    child: Text(
                      'Expense,%:',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 12.sp,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '-',
                    style: TextStyle(
                      color: const Color(0xFF1DACD6),
                      fontSize: 12.sp,
                      fontFamily: 'SF Compact Rounded',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Opacity(
                    opacity: 0.40,
                    child: Text(
                      'Ratio:',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 12.sp,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '-',
                    style: TextStyle(
                      color: const Color(0xFFFAFAFA),
                      fontSize: 12.sp,
                      fontFamily: 'SF Compact Rounded',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: 0,
              backgroundColor: const Color(0xFF1DACD6),
              color: const Color(0xFF7CB342),
              minHeight: 10.h,
            ),
          ),
          SizedBox(height: 24.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.asset(
              'assets/images/analitika.png',
              height: 424.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsContent(List<Sale> filteredSales, double totalSales) {
    final bool hasData = totalSales > 0;

    double expense = hasData ? totalSales * 0.2 : 0.0;
    double income = hasData ? (totalSales - expense) : 0.0;

    double incomePercent = (hasData ? (income / totalSales) : 0) * 100;
    double expensePercent = (hasData ? (expense / totalSales) : 0) * 100;

    double ratioValue = (expense == 0) ? 0 : (income / expense);
    String ratioText =
        ratioValue == 0 ? '-' : '${ratioValue.toStringAsFixed(2)}:1';

    final categoryMap = sumByCategory(filteredSales);
    final sortedCategoryEntries =
        categoryMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final topCategoryName =
        sortedCategoryEntries.isNotEmpty
            ? sortedCategoryEntries.first.key
            : '-';

    final monthName = DateFormat.yMMMM().format(selectedDate);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      child: Column(
        children: [
          Container(
            width: 311.w,
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: ShapeDecoration(
              color: const Color(0xFF7CB342),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current month profit:',
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: 14.sp,
                    fontFamily: 'SF Compact Rounded',
                    fontWeight: FontWeight.w400,
                    height: 1.40,
                  ),
                ),
                Text(
                  hasData ? '\$ ${totalSales.toStringAsFixed(2)}' : '-',
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: 14.sp,
                    fontFamily: 'SF Compact Rounded',
                    fontWeight: FontWeight.w600,
                    height: 1.40,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Opacity(
                    opacity: 0.40,
                    child: Text(
                      'Income, %:',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 12.sp,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    hasData ? '${incomePercent.toStringAsFixed(2)}%' : '-',
                    style: TextStyle(
                      color: const Color(0xFF7CB342),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Opacity(
                    opacity: 0.40,
                    child: Text(
                      'Expense, %:',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 12.sp,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    hasData ? '${expensePercent.toStringAsFixed(2)}%' : '-',
                    style: TextStyle(
                      color: const Color(0xFF1DACD6),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Opacity(
                    opacity: 0.40,
                    child: Text(
                      'Ratio:',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 12.sp,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    hasData ? ratioText : '-',
                    style: TextStyle(
                      color: const Color(0xFFFAFAFA),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),

          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: hasData ? (incomePercent / 100) : 0,
              backgroundColor: const Color(0xFF1DACD6),
              color: const Color(0xFF7CB342),
              minHeight: 10.h,
            ),
          ),
          SizedBox(height: 40.h),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top category in sales:',
                style: TextStyle(
                  color: const Color(0xFFFAFAFA),
                  fontSize: 16,
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: ShapeDecoration(
                  color: const Color(0xFF343434),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/crown.svg",
                      color: _pieColors()[0],
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      hasData ? topCategoryName : '-',
                      style: TextStyle(
                        color: _pieColors()[0],
                        fontSize: 16,
                        fontFamily: 'SF Compact Rounded',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 32.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _goToPreviousMonth,
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              Text(
                monthName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFFAFAFA),
                  fontSize: 16,
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
              IconButton(
                onPressed: _goToNextMonth,
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          FutureBuilder<bool>(
            future: getBakeBudgetPrem(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final hasPremium = snapshot.data ?? false;

              if (!hasPremium) {
                return _buildPaywallCard(context);
              }

              return Column(
                children: [
                  _buildDonutChart(categoryMap, totalSales, hasData),
                  SizedBox(height: 40.h),
                  _buildCategoryList(categoryMap, totalSales, hasData),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart(
    Map<String, double> categoryMap,
    double totalSales,
    bool hasData,
  ) {
    if (!hasData) {
      return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF343434),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: Text(
          'No data for this month',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14.sp,
            fontFamily: 'SF Compact Rounded',
          ),
        ),
      );
    }

    final sorted =
        categoryMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final sections = <PieChartSectionData>[];
    final colors = _pieColors();

    for (int i = 0; i < sorted.length; i++) {
      final entry = sorted[i];
      final categoryValue = entry.value;
      final percentage = (categoryValue / totalSales) * 100;
      final sectionColor = colors[i % colors.length];

      sections.add(
        PieChartSectionData(
          color: sectionColor,
          value: categoryValue,
          title: '',
          radius: 70.r,
          titleStyle: TextStyle(
            color: const Color(0xFFFAFAFA),
            fontSize: 12,
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
          badgePositionPercentageOffset: 0.8,
          badgeWidget: Card(
            elevation: 4,
            color: const Color(0xffFAFAFA).withOpacity(0.4),
            child: Container(
              width: 48.w,
              height: 48.h,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: Text(
                '${percentage.toStringAsFixed(1)}%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFFAFAFA),
                  fontSize: 12,
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ),
          ),
          showTitle: true,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(20.0.r),
      child: SizedBox(
        height: 300.h,
        child: PieChart(
          PieChartData(
            sections: sections,
            centerSpaceRadius: 100.r,
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
          ),
          swapAnimationDuration: const Duration(milliseconds: 400),
          swapAnimationCurve: Curves.easeInOut,
        ),
      ),
    );
  }

  Widget _buildCategoryList(
    Map<String, double> categoryMap,
    double totalSales,
    bool hasData,
  ) {
    if (!hasData) {
      return Container(
        width: double.infinity,
        height: 80.h,
        decoration: BoxDecoration(
          color: const Color(0xFF343434),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: Text(
          'No categories',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14.sp,
            fontFamily: 'SF Compact Rounded',
          ),
        ),
      );
    }

    final sorted =
        categoryMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final colors = _pieColors();

    return Column(
      children: [
        for (int i = 0; i < sorted.length; i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 10,
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(1.00, 0.00),
                        end: const Alignment(-1, 0),
                        colors: [
                          const Color(0xFF00231F),
                          colors[i % colors.length],
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    sorted[i].key,
                    style: TextStyle(
                      color: const Color(0xFFFAFAFA),
                      fontSize: 14.sp,
                      fontFamily: 'SF Compact Rounded',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              Text(
                '\$ ${sorted[i].value.toStringAsFixed(2)}',
                style: TextStyle(
                  color: const Color(0xFFFAFAFA),
                  fontSize: 14,
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w400,
                  height: 1.40,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }

  Widget _buildPaywallCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PreiumBakebudget()),
        );
      },
      child: Image.asset("assets/images/premium_settings.png", width: 311.w),
    );
  }

  List<Color> _pieColors() {
    return const [
      Color(0xFF29B6F6),
      Color(0xFFFFA726),
      Color(0xFF66BB6A),
      Color(0xFFFF7043),
      Color(0xFFAB47BC),
      Color(0xFFEC407A),
      Color(0xFFFFCA28),
    ];
  }
}
