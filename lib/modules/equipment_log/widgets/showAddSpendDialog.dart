import 'package:bakebudget_pastry_office_185t/modules/equipment_log/models/equipment_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/models/equipment_spend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

void showAddSpendDialogBakeBudget(BuildContext context, Equipment equipment) {
  TextEditingController costControllerBakeBudget = TextEditingController();

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return CupertinoAlertDialog(
            title: Text(
              'Add spend',
              style: TextStyle(
                fontSize: 20.sp,
                color: const Color(0xFF1E1E1E),
                fontFamily: 'SF Compact Rounded',
                fontWeight: FontWeight.w500,
              ),
            ),
            content: Column(
              children: [
                SizedBox(height: 8.h),
                Text(
                  'Enter the amount spent on repair/replacement of equipment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF4D4D4D),
                    fontFamily: 'SF Compact Rounded',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 12.h),
                CupertinoTextField(
                  controller: costControllerBakeBudget,
                  placeholder: "Enter cost",
                  keyboardType: TextInputType.number,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: const Color(0xFF007AFF),
                    fontFamily: 'SF Compact Rounded',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed:
                    costControllerBakeBudget.text.isNotEmpty
                        ? () async {
                          double? amount = double.tryParse(
                            costControllerBakeBudget.text,
                          );
                          if (amount != null) {
                            final spendBox = await Hive.openBox<EquipmentSpend>(
                              'equipmentSpendBox',
                            );
                            final spend = EquipmentSpend(
                              amount: amount,
                              date: DateTime.now(),
                              equipmentName: equipment.name,
                            );
                            await spendBox.add(spend);
                            Navigator.pop(context);
                          }
                        }
                        : null,
                child: Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 17.sp,
                    color:
                        costControllerBakeBudget.text.isNotEmpty
                            ? const Color(0xFF007AFF)
                            : const Color(0xFF96B3D3),
                    fontFamily: 'SF Compact Rounded',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
