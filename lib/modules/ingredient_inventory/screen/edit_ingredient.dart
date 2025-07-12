import 'package:bakebudget_pastry_office_185t/bakebudget_notificationservice.dart';
import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/models/ingredient_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/widgets/showDatePicker_bakebudget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class EditIngredient extends StatefulWidget {
  final Ingredient ingredient;
  final int index;
  const EditIngredient({
    super.key,
    required this.ingredient,
    required this.index,
  });

  @override
  State<EditIngredient> createState() => _EditIngredientState();
}

class _EditIngredientState extends State<EditIngredient> {
  late TextEditingController _nameController;
  late TextEditingController _costController;
  late DateTime selectedDate;
  late bool _notificationEnabled;

  late String initialName;
  late String initialCost;
  late DateTime initialDate;
  late bool initialNotificationEnabled;

  @override
  void initState() {
    super.initState();
    initialName = widget.ingredient.name;
    initialCost = widget.ingredient.cost.toString();
    initialDate = widget.ingredient.notificationDate;
    initialNotificationEnabled = widget.ingredient.notificationEnabled;

    _nameController = TextEditingController(text: initialName);
    _costController = TextEditingController(text: initialCost);
    selectedDate = initialDate;
    _notificationEnabled = initialNotificationEnabled;
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

  bool get _hasUnsavedChanges {
    return _nameController.text.trim() != initialName ||
        _costController.text.trim() != initialCost ||
        selectedDate != initialDate ||
        _notificationEnabled != initialNotificationEnabled;
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    } else {
      return await showCupertinoDialog<bool>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                  'Leave the page',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w600,
                    height: 1.29,
                    letterSpacing: -0.41,
                  ),
                ),
                content: Text(
                  'Are you sure you want to leave the page? Unsaved changes will be lost.',
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

  Future<void> _updateIngredient() async {
    if (_nameController.text.isNotEmpty &&
        _costController.text.isNotEmpty &&
        _isDateValid) {
      final ingredientBox = Hive.box<Ingredient>('ingredients');
      final updatedIngredient = Ingredient(
        name: _nameController.text.trim(),
        cost: double.tryParse(_costController.text.trim()) ?? 0.0,
        notificationEnabled: _notificationEnabled,
        notificationDate: selectedDate,
      );
      await ingredientBox.putAt(widget.index, updatedIngredient);
      Navigator.pop(context);
    }
  }

  Future<void> _deleteIngredient() async {
    final shouldDelete = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'Delete Ingredient',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to remove this ingredient? This action cannot be canceled. ',
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
              child: const Text(
                'Delete',
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
      final ingredientBox = Hive.box<Ingredient>('ingredients');
      await ingredientBox.deleteAt(widget.index);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool disableDatePicker = _notificationEnabled && !_isDateValid;
    final bool enableSaveButton =
        _nameController.text.isNotEmpty &&
        _costController.text.isNotEmpty &&
        _isDateValid;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFF1E1E1E),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E1E1E),
            elevation: 0,
            title: const Text(
              'Edit ingredient',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF1DACD6),
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
            actions: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/delet.svg',
                  width: 24.w,
                  height: 24.h,
                ),
                onPressed: _deleteIngredient,
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    '1. Specify ingredient name',
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
                    '2. Specify ingredient cost',
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
                    child: Text(
                      'Low ingredient inventory (optional)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.cyan,
                        decoration: TextDecoration.underline,
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
                  _buildNotificationToggle(),
                  SizedBox(height: 16.h),
                  _buildDateSelection(disableDatePicker),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildSaveButton(enableSaveButton),
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
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Color(0xFF838383),
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
          filled: true,
          fillColor: Color(0xFF343434),
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
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter cost',
          hintStyle: TextStyle(
            color: Color(0xFF838383),
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
          filled: true,
          fillColor: Color(0xFF343434),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1DACD6),
              borderRadius: BorderRadius.circular(8.r),
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
        color: Color(0xFF343434),
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
          Spacer(),
          Switch(
            value: _notificationEnabled,
            activeColor: Color(0xFF1DACD6),
            onChanged: (value) async {
              if (value) {
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
          color: disableDatePicker ? Colors.grey : Color(0xFF343434),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM dd, yyyy').format(selectedDate),
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
                  color: disableDatePicker ? Colors.grey : Color(0xFF1DACD6),
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
        onPressed: enableButton ? _updateIngredient : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1DACD6),
          disabledBackgroundColor: Color(0xFF1E4B59),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
}
