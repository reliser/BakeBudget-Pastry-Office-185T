import 'package:bakebudget_pastry_office_185t/bakebudget_notificationservice.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/models/equipment_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/models/equipment_spend.dart';
import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/widgets/showDatePicker_bakebudget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class EditEquipmentLog extends StatefulWidget {
  final Equipment equipment;
  final int index;

  const EditEquipmentLog({
    super.key,
    required this.equipment,
    required this.index,
  });

  @override
  State<EditEquipmentLog> createState() => _EditEquipmentLogState();
}

class _EditEquipmentLogState extends State<EditEquipmentLog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  bool _notificationEnabled = false;
  DateTime selectedDate = DateTime.now();

  late String initialName;
  late String initialCost;
  late bool initialNotificationEnabled;
  late DateTime initialDate;

  @override
  void initState() {
    super.initState();

    initialName = widget.equipment.name;
    initialCost = widget.equipment.cost.toString();
    initialNotificationEnabled = widget.equipment.notificationEnabled;
    initialDate = widget.equipment.notificationDate;

    _nameController.text = initialName;
    _costController.text = initialCost;
    _notificationEnabled = initialNotificationEnabled;
    selectedDate = initialDate;
  }

  bool get _isDateValid {
    if (!_notificationEnabled) return true;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final chosenDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    return !chosenDate.isBefore(today);
  }

  bool get _hasUnsavedChanges {
    if (_nameController.text.trim() != initialName.trim()) return true;
    if (_costController.text.trim() != initialCost.trim()) return true;
    if (_notificationEnabled != initialNotificationEnabled) return true;
    if (selectedDate != initialDate) return true;
    return false;
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    } else {
      final result = await showCupertinoDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              'Leave the page',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Are you sure you want to leave the page? Unsaved changes will be lost.',
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
                onPressed: () => Navigator.pop(context, false),
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
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        },
      );
      return result ?? false;
    }
  }

  void _onNotificationToggle(bool value) async {
    if (value) {
      bool permissionGranted =
          await BakebudgetNotificationService().requestPermission();
      if (!permissionGranted) {
        _showPermissionDialog();
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
  }

  void _showPermissionDialog() {
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
              "Allow access in Settings so you don't forget about an important equipment repair’s",
              style: TextStyle(fontSize: 14),
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

  Future<void> _deleteEquipment() async {
    final shouldDelete = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'Delete Equipment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to remove this equipment? This action cannot be undone. ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'SF Pro Text',
              fontWeight: FontWeight.w400,
              height: 1.38,
              letterSpacing: -0.08,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(
                'Delete',
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
    );

    if (shouldDelete == true) {
      final box = Hive.box<Equipment>('equipmentBox');
      await box.deleteAt(widget.index);
      Navigator.pop(context);
    }
  }

  void _saveChanges() {
    if (_nameController.text.isNotEmpty &&
        _costController.text.isNotEmpty &&
        _isDateValid) {
      final box = Hive.box<Equipment>('equipmentBox');
      final updatedEquipment = Equipment(
        name: _nameController.text.trim(),
        cost: double.tryParse(_costController.text.trim()) ?? 0.0,
        notificationEnabled: _notificationEnabled,
        notificationDate: selectedDate,
      );
      box.putAt(widget.index, updatedEquipment);

      initialName = _nameController.text;
      initialCost = _costController.text;
      initialNotificationEnabled = _notificationEnabled;
      initialDate = selectedDate;

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool disableDatePicker = _notificationEnabled && !_isDateValid;
    final bool enableSaveButton =
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
            title: const Text(
              'Edit equipment',
              style: TextStyle(
                color: Color(0xFF1DACD6),
                fontSize: 20,
                fontFamily: 'SF Compact Rounded',
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back, color: Colors.white),
              onPressed: () async {
                final shouldPop = await _onWillPop();
                if (shouldPop) Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                onPressed: _deleteEquipment,
                icon: SvgPicture.asset(
                  'assets/icons/delet.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
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
                            color: const Color(0xFF1DACD6),
                            fontFamily: 'SF Compact Rounded',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '\n(optional)',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF1D5768),
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
                  '3. Specify the date for notification',
                  style: TextStyle(
                    color: const Color(0xFFFAFAFA),
                    fontFamily: 'SF Compact Rounded',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildNotificationToggle(disableDatePicker),
                SizedBox(height: 16.h),
                _buildDateSelection(disableDatePicker),
                SizedBox(height: 16.h),

                _buildSpendList(),
                SizedBox(height: 100.h),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildSaveButton(enableSaveButton),
        ),
      ),
    );
  }

  Widget _buildSpendList() {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<EquipmentSpend>('equipmentSpendBox').listenable(),
      builder: (context, Box<EquipmentSpend> spendBox, _) {
        final spends =
            spendBox.values
                .where((spend) => spend.equipmentName == widget.equipment.name)
                .toList();

        if (spends.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: Color(0xFF343434), height: 1),
            SizedBox(height: 16.h),
            Text(
              'Repairs/maintenance:',
              style: TextStyle(
                color: const Color(0xFF1DACD6),
                fontSize: 20,
                fontFamily: 'SF Compact Rounded',
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
            SizedBox(height: 14.h),

            Column(
              children:
                  spends.asMap().entries.map((entry) {
                    final spendIndex = entry.key;
                    final spend = entry.value;
                    return _buildSpendItem(spend, spendIndex);
                  }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSpendItem(EquipmentSpend spend, int spendIndex) {
    return Container(
      width: 311.w,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: ShapeDecoration(
        color: const Color(0xFF343434),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${spend.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: const Color(0xFFFAFAFA),
                  fontSize: 14,
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w400,
                  height: 1.40,
                ),
              ),
              Text(
                DateFormat('MMMM dd, yyyy – HH:mm').format(spend.date),
                style: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 12,
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ],
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF1DACD6)),
                onPressed: () => _showEditSpendDialog(spend, spendIndex),
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                onPressed: () => _deleteSpend(spendIndex),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSpend(int spendIndex) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text(
              'Delete spend',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('Are you sure you want to delete this spend?'),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text(
                  'Delete',
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (result == true) {
      final spendBox = Hive.box<EquipmentSpend>('equipmentSpendBox');

      final spends =
          spendBox.values
              .where((spend) => spend.equipmentName == widget.equipment.name)
              .toList();
      final spendToDelete = spends[spendIndex];

      final keyToDelete = spendBox.keys.firstWhere(
        (key) => spendBox.get(key) == spendToDelete,
      );
      await spendBox.delete(keyToDelete);
    }
  }

  void _showEditSpendDialog(EquipmentSpend spend, int spendIndex) {
    final TextEditingController spendController = TextEditingController(
      text: spend.amount.toStringAsFixed(2),
    );

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            return CupertinoAlertDialog(
              title: const Text('Edit spend'),
              content: Column(
                children: [
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: spendController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+(\.\d+)?'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                  onPressed: () async {
                    double? newAmount = double.tryParse(spendController.text);
                    if (newAmount != null) {
                      final spendBox = Hive.box<EquipmentSpend>(
                        'equipmentSpendBox',
                      );

                      final spends =
                          spendBox.values
                              .where(
                                (s) => s.equipmentName == widget.equipment.name,
                              )
                              .toList();
                      final spendToUpdate = spends[spendIndex];
                      final keyToUpdate = spendBox.keys.firstWhere(
                        (key) => spendBox.get(key) == spendToUpdate,
                      );

                      final updatedSpend = EquipmentSpend(
                        amount: newAmount,
                        date: spendToUpdate.date,
                        equipmentName: spendToUpdate.equipmentName,
                      );
                      await spendBox.put(keyToUpdate, updatedSpend);
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
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
            borderRadius: BorderRadius.circular(8.r),
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
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1DACD6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: const Icon(Icons.attach_money, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(bool disableDatePicker) {
    return Container(
      width: 311.w,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF343434),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/notification.svg',
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(width: 10.w),
          Text(
            'Notification',
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          const Spacer(),
          Switch(
            value: _notificationEnabled,
            activeColor: const Color(0xFF1DACD6),
            onChanged: disableDatePicker ? null : _onNotificationToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection(bool disableDatePicker) {
    return GestureDetector(
      onTap:
          disableDatePicker
              ? null
              : () {
                showDatePickerDialogBakeBudget(context, selectedDate, (
                  newDate,
                ) {
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

  Widget _buildSaveButton(bool enableButton) {
    return SizedBox(
      width: 311.w,
      height: 48.h,
      child: ElevatedButton(
        onPressed: enableButton ? _saveChanges : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1DACD6),
          disabledBackgroundColor: const Color(0xFF1E4B59),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
