import 'package:bakebudget_pastry_office_185t/modules/onboarding/loading_bakebudget.dart';
import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/cubits/sales_cubit_bakebudget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBakeBudget extends StatelessWidget {
  const MyAppBakeBudget({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (context) => SalesCubitBakeBudget()..loadSales(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: LoadingScreenBakeBudget(),
        ),
      ),
    );
  }
}
