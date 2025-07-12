import 'package:bakebudget_pastry_office_185t/modules/equipment_log/models/equipment_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/widgets/showAddSpendDialog.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/models/equipment_spend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class EquipmentCard extends StatelessWidget {
  final Equipment equipment;

  const EquipmentCard({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<EquipmentSpend>('equipmentSpendBox').listenable(),
      builder: (context, Box<EquipmentSpend> spendBox, _) {
        final totalSpends = spendBox.values
            .where((spend) => spend.equipmentName == equipment.name)
            .fold<double>(
              0.0,
              (previousValue, element) => previousValue + element.amount,
            );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Container(
            width: 311.w,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF343434),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      equipment.name,
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color(0xFF1DACD6),
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (equipment.notificationEnabled)
                      SvgPicture.asset(
                        'assets/icons/notification.svg',
                        width: 24.w,
                        height: 24.h,
                      ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Cost: ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF838383),
                          fontFamily: 'SF Compact Rounded',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: '\$${equipment.cost.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontFamily: 'SF Compact Rounded',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Notification Date: ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF838383),
                          fontFamily: 'SF Compact Rounded',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: DateFormat(
                          'MMMM dd, yyyy',
                        ).format(equipment.notificationDate),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1DACD6),
                          fontFamily: 'SF Compact Rounded',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),

                if (totalSpends > 0)
                  SizedBox(
                    width: 279,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Repairs/maintenance:',
                            style: TextStyle(
                              color: const Color(0xFFFAFAFA),
                              fontSize: 14,
                              fontFamily: 'SF Compact Rounded',
                              fontWeight: FontWeight.w400,
                              height: 1.40,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '\$ ${totalSpends.toStringAsFixed(2)}',
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
                  ),

                16.verticalSpace,
                GestureDetector(
                  onTap: () {
                    showAddSpendDialogBakeBudget(context, equipment);
                  },
                  child: Container(
                    height: 44.h,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1DACD6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Add spend',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 16,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
