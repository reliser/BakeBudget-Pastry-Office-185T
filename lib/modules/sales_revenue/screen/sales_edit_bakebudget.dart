import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/models/sale_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/cubits/sales_cubit_bakebudget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditSalesBakeBudget extends StatefulWidget {
  final Sale sale;
  final int saleIndex;

  const EditSalesBakeBudget({
    super.key,
    required this.sale,
    required this.saleIndex,
  });

  @override
  State<EditSalesBakeBudget> createState() => _EditSalesBakeBudgetState();
}

class _EditSalesBakeBudgetState extends State<EditSalesBakeBudget> {
  late TextEditingController _nameController;
  late TextEditingController _costController;
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sale.name);
    _costController = TextEditingController(
      text: widget.sale.cost.toStringAsFixed(2),
    );
    _selectedCategory = widget.sale.category;
  }

  bool get _hasUnsavedChanges {
    return _selectedCategory != widget.sale.category ||
        _nameController.text.trim() != widget.sale.name ||
        _costController.text.trim() != widget.sale.cost.toString();
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
                  'Are you sure you want to leave the page?  This sale changes will not be saved',
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

  void _updateSale() {
    final String category = _selectedCategory!;
    final String name = _nameController.text.trim();
    final double? cost = double.tryParse(_costController.text.trim());
    if (name.isNotEmpty && cost != null) {
      context.read<SalesCubitBakeBudget>().updateSale(
        widget.saleIndex,
        category: category,
        name: name,
        cost: cost,
      );
      Navigator.pop(context);
    }
  }

  void _deleteSale() async {
    final bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Delete sales"),
          content: const Text(
            'Are you sure you want to delete this sale? This action cannot be canceled. ',
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
    if (confirmed == true) {
      context.read<SalesCubitBakeBudget>().deleteSale(widget.saleIndex);
      Navigator.pop(context);
    }
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

  Widget _buildUpdateButton() {
    return SizedBox(
      width: 311.w,
      height: 48.h,
      child: ElevatedButton(
        onPressed:
            (_selectedCategory != null &&
                    _nameController.text.isNotEmpty &&
                    _costController.text.isNotEmpty)
                ? _updateSale
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1DACD6),
          disabledBackgroundColor: const Color(0xFF1E4B59),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: const Text(
          'Save Changes',
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFF1E1E1E),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xFF1E1E1E),
            elevation: 0,
            title: Text(
              'Edit sale',
              style: TextStyle(
                fontSize: 20.sp,
                color: const Color(0xFF1DACD6),
                fontFamily: 'SF Compact Rounded',
                fontWeight: FontWeight.w500,
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
            actions: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/delet.svg',
                  width: 24.w,
                  height: 24.h,
                ),
                onPressed: _deleteSale,
              ),
              SizedBox(width: 24.w),
            ],
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
                const Spacer(),
                _buildUpdateButton(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
