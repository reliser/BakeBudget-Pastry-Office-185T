import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/cubits/sales_cubit_bakebudget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddSalesBakeBudget extends StatefulWidget {
  const AddSalesBakeBudget({super.key});

  @override
  State<AddSalesBakeBudget> createState() => _AddSalesBakeBudgetState();
}

class _AddSalesBakeBudgetState extends State<AddSalesBakeBudget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = [
    "Bakery products",
    "Sweet pastries",
    "Confectionery",
    "Sand & puff pastry",
    "Fruit pastries",
    "Other",
  ];

  bool _isDropdownOpen = false;

  bool get _hasUnsavedChanges {
    return _selectedCategory != null ||
        _nameController.text.isNotEmpty ||
        _costController.text.isNotEmpty;
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    } else {
      return await showCupertinoDialog<bool>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text("Leave the page"),
                content: const Text(
                  "Are you sure you want to leave? This sale will not be added.",
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
                    onPressed: () => Navigator.pop(context, true),
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
                  ),
                ],
              );
            },
          ) ??
          false;
    }
  }

  void _addSale() {
    final String category = _selectedCategory!;
    final String name = _nameController.text.trim();
    final double? cost = double.tryParse(_costController.text.trim());
    if (name.isNotEmpty && cost != null) {
      context.read<SalesCubitBakeBudget>().addSale(
        category: category,
        name: name,
        cost: cost,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: const Color(0xFF1E1E1E),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E1E1E),
            elevation: 0,
            title: Text(
              'Add sale',
              textAlign: TextAlign.center,
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
              onPressed: () {
                _onWillPop().then((value) {
                  if (value) Navigator.pop(context);
                });
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  '1. Select the category of product sold',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                SizedBox(height: 10.h),
                _buildCategoryDropdown(),
                SizedBox(height: 16.h),
                Text(
                  '2. Specify the name of the item sold',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                SizedBox(height: 10.h),
                _buildTextField(_nameController, 'Enter name'),
                SizedBox(height: 16.h),
                Text(
                  '3. Specify the amount for which this product was sold',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                SizedBox(height: 10.h),
                _buildCostTextField(),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildAddButton(),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDropdownOpen = !_isDropdownOpen;
        });
      },
      child: Container(
        width: 311.w,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF343434),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Burst-Bloat.svg",
                      width: 24.w,
                      height: 24.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _selectedCategory ?? "Select category",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'SF Compact Rounded',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isDropdownOpen ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                ),
              ],
            ),
            if (_isDropdownOpen)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _categories.map((category) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                                _isDropdownOpen = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Opacity(
                                opacity: 0.60,
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'SF Compact Rounded',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white38,
                            thickness: 0.3,
                            height: 0,
                          ),
                        ],
                      );
                    }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return SizedBox(
      width: 311.w,
      height: 48.h,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF838383)),
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
      width: 311.w,
      height: 48.h,
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: _costController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter cost',
          hintStyle: const TextStyle(color: Color(0xFF838383)),
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

  Widget _buildAddButton() {
    return SizedBox(
      width: 311.w,
      height: 48.h,
      child: ElevatedButton(
        onPressed:
            (_selectedCategory != null &&
                    _nameController.text.isNotEmpty &&
                    _costController.text.isNotEmpty)
                ? _addSale
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1DACD6),
          disabledBackgroundColor: const Color(0xFF1E4B59),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: const Text(
          'Add',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFAFAFA),
            fontSize: 16,
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}
