import 'package:apphud/apphud.dart';
import 'package:bakebudget_pastry_office_185t/bakebudget_prem.dart';
import 'package:bakebudget_pastry_office_185t/components/bottom_bar_bakebudget.dart';
import 'package:bakebudget_pastry_office_185t/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

class PreiumBakebudget extends StatefulWidget {
  const PreiumBakebudget({super.key});
  @override
  State<PreiumBakebudget> createState() => _PreiumBakebudgetState();
}

class _PreiumBakebudgetState extends State<PreiumBakebudget> {
  bool isLoading = false;

  final ValueNotifier<bool> preSavca = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/premium.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),

          Positioned(
            left: 32.w,
            right: 32.w,
            top: 42.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      webBakeBudgetPrem(context, 'https://docs.google.com/document/d/1CJCsVPCh0flcL7BWdlE3q1Es2eiNhf4KKorC3-UTp5c/edit?usp=sharing');
                    },
                    child: Text(
                      'Terms of use',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 14.sp,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                        letterSpacing: 0.28,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      restoreBakeBudgetPrem(context);
                    },
                    child: Text(
                      'Restore',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 14.sp,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                        letterSpacing: 0.28,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      webBakeBudgetPrem(context, 'https://docs.google.com/document/d/1d_P_9AmcnJpn0J3ArrX7EnWZZs7ThPXsc3uRxaYHdG8/edit?usp=sharing');
                    },
                    child: Text(
                      'Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 14.sp,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                        letterSpacing: 0.28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 45.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      var splashBox = await Hive.openBox('appStorageBox');
                      await splashBox.put('hasSeenSplash', true);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const BottomBarPastryOfficeBakeBudget(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SF Compact Rounded',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    preSavca.value = true;
                    setState(() {
                      isLoading = true;
                    });
                    final placements = await Apphud.placements();
                    if (placements.isNotEmpty &&
                        placements.first.paywall?.products != null &&
                        placements.first.paywall!.products!.isNotEmpty) {
                      await Apphud.purchase(
                        product: placements.first.paywall!.products!.first,
                      ).whenComplete(() async {
                        if (await Apphud.hasPremiumAccess() ||
                            await Apphud.hasActiveSubscription()) {
                          await setBakeBudgetPrem();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const BottomBarPastryOfficeBakeBudget(),
                            ),
                            (route) => false,
                          );
                        }
                      });
                    }
                    preSavca.value = false;
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Container(
                    width: 160.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8E1B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child:
                        isLoading
                            ? const CupertinoActivityIndicator(
                              color: Colors.white,
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/premium_icon.svg',
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Go premium',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'SF Compact Rounded',
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
