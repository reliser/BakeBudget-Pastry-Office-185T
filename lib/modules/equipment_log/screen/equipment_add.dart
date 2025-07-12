import 'package:bakebudget_pastry_office_185t/bakebudget_notificationservice.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/models/equipment_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/widgets/showDatePicker_bakebudget.dart';
import 'package:bakebudget_pastry_office_185t/bakebudget_prem.dart';
import 'package:bakebudget_pastry_office_185t/modules/onboarding/preium_bakebudget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AddEquipmentLog extends StatefulWidget {
  const AddEquipmentLog({super.key});

  @override
  State<AddEquipmentLog> createState() => _AddEquipmentLogState();
}

class _AddEquipmentLogState extends State<AddEquipmentLog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  bool _notificationEnabled = false;
  DateTime selectedDate = DateTime.now();

  bool? _isPremium;

  @override
  void initState() {
    super.initState();
    _checkPremium();
  }

  Future<void> _checkPremium() async {
    final premium = await getBakeBudgetPrem();
    setState(() {
      _isPremium = premium;
    });
  }

  bool get _isDateValid {
    if (!_notificationEnabled) return true;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    return !selected.isBefore(today);
  }

  Future<void> _saveEquipment() async {
    if (_nameController.text.isNotEmpty &&
        _costController.text.isNotEmpty &&
        _isDateValid) {
      final box = Hive.box<Equipment>('equipmentBox');
      final equipment = Equipment(
        name: _nameController.text,
        cost: double.parse(_costController.text),
        notificationEnabled: _notificationEnabled,
        notificationDate: selectedDate,
      );
      await box.add(equipment);
      Navigator.pop(context);
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Access to Push Notifications has been denied",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Allow access in Settings so you don't forget about an important payment’s",
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                "Cancel",
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
                "Settings",
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
              onPressed: () {
                Navigator.pop(context);
                BakebudgetNotificationService().openAppSettingsBakeBudget();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (_nameController.text.isEmpty && _costController.text.isEmpty) {
      return true;
    } else {
      return await showCupertinoDialog<bool>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text(
                  'Leave the page',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: const Text(
                  'Are you sure you want to leave the page? This equipment will not be saved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 17,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.w400,
                        height: 1.29,
                        letterSpacing: -0.41,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text(
                      'Leave',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 17,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.w600,
                        height: 1.29,
                        letterSpacing: -0.41,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          ) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPremium == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final bool disableDatePicker = _notificationEnabled && !_isDateValid;
    final bool enableAddButton =
        _nameController.text.isNotEmpty &&
        _costController.text.isNotEmpty &&
        _isDateValid;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFF1E1E1E),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E1E1E),
            elevation: 0,
            title: Text(
              'Add equipment',
              style: TextStyle(
                fontSize: 20,
                color: const Color(0xFF1DACD6),
                fontFamily: 'SF Compact Rounded',
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back, color: Colors.white),
              onPressed: () async {
                final shouldPop = await _onWillPop();
                if (shouldPop) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      '1. Specify the equipment name',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _buildTextField(_nameController, 'Enter name'),
                    SizedBox(height: 16.h),
                    Text(
                      '2. Specify the cost of equipment',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _buildCostTextField(),
                    SizedBox(height: 16.h),

                    GestureDetector(
                      onTap: () {},
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Specify the date of the reminder\nto replace/repair this equipment ',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xFFFF8E1B),
                                fontFamily: 'SF Compact Rounded',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '\n(optional)',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xFFFF8E1B),
                                fontFamily: 'SF Compact Rounded',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      '1. Specify the date for notification',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _buildNotificationToggle(),
                    SizedBox(height: 16.h),
                    _buildDateSelection(disableDatePicker),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildAddButton(enableAddButton),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return SizedBox(
      width: 311,
      height: 48,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF838383),
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFF343434),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCostTextField() {
    return SizedBox(
      width: 311,
      height: 48,
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: _costController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter cost',
          hintStyle: const TextStyle(
            color: Color(0xFF838383),
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFF343434),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1DACD6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.attach_money, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Container(
      width: 311.w,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF343434),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/notification.svg',
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Color(0xFFFF8E1B),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 10.w),
          const Text(
            'Notification',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Spacer(),
          Switch(
            value: _notificationEnabled,
            activeColor: const Color(0xFF1DACD6),
            onChanged: (value) async {
              if (_isPremium == false && value == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PreiumBakebudget()),
                );
              } else if (value) {
                bool permissionGranted =
                    await BakebudgetNotificationService().requestPermission();
                if (!permissionGranted) {
                  _showPermissionDialog(context);
                  setState(() {
                    _notificationEnabled = false;
                  });
                } else {
                  setState(() {
                    _notificationEnabled = true;
                  });
                }
              } else {
                setState(() {
                  _notificationEnabled = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection(bool disableDatePicker) {
    return GestureDetector(
      onTap: () {
        if (_isPremium == false) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PreiumBakebudget()),
          );
          return;
        }

        if (disableDatePicker) return;

        showDatePickerDialogBakeBudget(context, selectedDate, (newDate) {
          setState(() {
            selectedDate = newDate;
          });
        });
      },
      child: Container(
        width: 311,
        height: 48,
        decoration: BoxDecoration(
          color: disableDatePicker ? Colors.grey : const Color(0xFF343434),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM dd yyyy').format(selectedDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              Text(
                'Select',
                style: TextStyle(
                  fontSize: 14,
                  color:
                      disableDatePicker ? Colors.grey : const Color(0xFF1DACD6),
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(bool enableButton) {
    return SizedBox(
      width: 311.w,
      height: 48.h,
      child: ElevatedButton(
        onPressed: enableButton ? _saveEquipment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1DACD6),
          disabledBackgroundColor: const Color(0xFF1E4B59),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Add',
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }
}
