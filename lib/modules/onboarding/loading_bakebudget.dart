import 'package:bakebudget_pastry_office_185t/components/bottom_bar_bakebudget.dart';
import 'package:bakebudget_pastry_office_185t/modules/onboarding/onboarding_bakebudget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

class LoadingScreenBakeBudget extends StatefulWidget {
  const LoadingScreenBakeBudget({super.key});

  @override
  State<LoadingScreenBakeBudget> createState() =>
      _LoadingScreenBakeBudgetState();
}

class _LoadingScreenBakeBudgetState extends State<LoadingScreenBakeBudget> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        _navigateToWelcome();
      });
    });
  }

  Future<void> _navigateToWelcome() async {
    var box = await Hive.openBox('splashBox');
    bool hasSeenSplash = box.get('splash', defaultValue: false);

    if (hasSeenSplash) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => BottomBarPastryOfficeBakeBudget()),
        (route) => false,
      );
    } else {
      await box.put('splash', true);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingBakeBudget()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: Center(
        child: Image.asset(
          "assets/images/loading.png",
          width: 240.w,
          height: 240.h,
        ),
      ),
    );
  }
}
