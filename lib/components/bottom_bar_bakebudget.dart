import 'package:bakebudget_pastry_office_185t/modules/%20analytics/analytics_bakebudget.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/screen/equipment_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/screen/ingredient_inventory.dart';
import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/screen/sales_revenue_bakebudget.dart';
import 'package:bakebudget_pastry_office_185t/modules/settings/setting_bakebudget.dart';

class BottomBarPastryOfficeBakeBudget extends StatefulWidget {
  const BottomBarPastryOfficeBakeBudget({super.key});

  @override
  State<BottomBarPastryOfficeBakeBudget> createState() =>
      _BottomBarPastryOfficeBakeBudgetState();
}

class _BottomBarPastryOfficeBakeBudgetState
    extends State<BottomBarPastryOfficeBakeBudget> {
  int selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    IngredientInventory(),
    EquipmentLog(),
    SalesRevenueBakeBudget(),
    AnalyticsBakeBudget(),
    SettingsScreenBakeBudget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E2025),
      body: Center(child: _widgetOptions[selectedIndex]),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 15.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: BottomNavigationBar(
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 16.8 / 12,
              letterSpacing: 0.02 * 12,
            ),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: const Color(0xff1E96FC),
            unselectedItemColor: const Color(0xff7D7D7D),
            backgroundColor: const Color(0xff323439),
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildBottomNavItem("but1_aktiv", "but1", 0),
              _buildBottomNavItem("but2_aktiv", "but2", 1),
              _buildBottomNavItem("but3_aktiv", "but3", 2),
              _buildBottomNavItem("but4_aktiv", "but4", 3),
              _buildBottomNavItem("but5_aktiv", "but5", 4),
            ],
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    String svgNameActive,
    String svgNameInactive,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.zero,
        child: SvgPicture.asset(
          'assets/icons/${selectedIndex == index ? svgNameActive : svgNameInactive}.svg',
          width: 48.w,
          height: 48.h,
          colorFilter:
              selectedIndex == index
                  ? null
                  : const ColorFilter.mode(Colors.white70, BlendMode.srcIn),
        ),
      ),
      label: "",
    );
  }
}
