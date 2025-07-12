import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/models/ingredient_model.dart';

class IngredientCardBakeBudget extends StatelessWidget {
  final Ingredient ingredient;
  final int index;

  const IngredientCardBakeBudget({
    super.key,
    required this.ingredient,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF343434),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ingredient.name,
                style: TextStyle(
                  color: const Color(0xFF1DACD6),
                  fontSize: 20,
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),

              if (ingredient.notificationEnabled)
                SvgPicture.asset('assets/icons/notification.svg'),
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
                  text: ingredient.cost.toStringAsFixed(2),
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
        ],
      ),
    );
  }
}
