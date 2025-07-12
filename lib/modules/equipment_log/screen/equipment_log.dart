import 'package:bakebudget_pastry_office_185t/modules/equipment_log/models/equipment_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/screen/equipment_add.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/screen/equipmentCard.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/screen/equipment_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class EquipmentLog extends StatefulWidget {
  const EquipmentLog({Key? key}) : super(key: key);

  @override
  State<EquipmentLog> createState() => _EquipmentLogState();
}

class _EquipmentLogState extends State<EquipmentLog> {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Equipment>('equipmentBox');
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        centerTitle: false,
        title: Text(
          'Equipment Log',
          style: TextStyle(
            color: const Color(0xFFFAFAFA),
            fontSize: 28.sp,
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Equipment> box, _) {
          if (box.isEmpty) {
            return Center(
              heightFactor: 1.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                  'assets/images/equipment.png',
                  height: 480.h,
                ),
              ),
            );
          }

          List<Equipment> equipments = box.values.toList();
          equipments.sort(
            (a, b) => a.notificationDate.compareTo(b.notificationDate),
          );

          Map<String, List<Equipment>> grouped = {};
          for (var e in equipments) {
            String dateKey = DateFormat(
              'MMMM dd, yyyy',
            ).format(e.notificationDate);
            grouped.putIfAbsent(dateKey, () => []);
            grouped[dateKey]!.add(e);
          }

          List<Widget> listWidgets = [];
          grouped.forEach((date, eqList) {
            listWidgets.add(
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: 0.40,
                      child: Text(
                        'Date:',
                        style: TextStyle(
                          color: const Color(0xFFFAFAFA),
                          fontSize: 12,
                          fontFamily: 'SF Compact Rounded',
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                    ),
                    SizedBox(width: 170.w),
                    Opacity(
                      opacity: 0.80,
                      child: Text(
                        date,
                        style: TextStyle(
                          color: const Color(0xFF1DACD6),
                          fontSize: 12,
                          fontFamily: 'SF Compact Rounded',
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            for (var equipment in eqList) {
              final equipmentIndex = equipments.indexOf(equipment);
              listWidgets.add(
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EditEquipmentLog(
                              equipment: equipment,
                              index: equipmentIndex,
                            ),
                      ),
                    );
                  },
                  child: EquipmentCard(equipment: equipment),
                ),
              );
            }
          });

          return ListView(
            padding: EdgeInsets.only(bottom: 100.h),
            children: listWidgets,
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 311.w,
        height: 48.h,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEquipmentLog()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1DACD6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Add',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontFamily: 'SF Compact Rounded',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
