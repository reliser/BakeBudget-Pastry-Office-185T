import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/models/ingredient_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/screen/add_ingredient.dart';
import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/screen/edit_ingredient.dart';
import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/screen/ingredientCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class IngredientInventory extends StatefulWidget {
  const IngredientInventory({super.key});

  @override
  State<IngredientInventory> createState() => _IngredientInventoryState();
}

class _IngredientInventoryState extends State<IngredientInventory> {
  @override
  Widget build(BuildContext context) {
    final ingredientBox = Hive.box<Ingredient>('ingredients');
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          'Ingredient Inventory',
          style: TextStyle(
            fontSize: 28.sp,
            color: const Color(0xFFFAFAFA),
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: ingredientBox.listenable(),
        builder: (context, Box<Ingredient> box, _) {
          if (box.isEmpty) {
            return Center(
              heightFactor: 1.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                  'assets/images/ingredient.png',
                  height: 464.h,
                ),
              ),
            );
          }

          List<Ingredient> ingredients = box.values.toList();
          ingredients.sort(
            (a, b) => a.notificationDate.compareTo(b.notificationDate),
          );

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              final currentDateStr = DateFormat(
                'MMMM d, y',
              ).format(ingredient.notificationDate);
              bool showHeader = false;
              if (index == 0) {
                showHeader = true;
              } else {
                final previousIngredient = ingredients[index - 1];
                final previousDateStr = DateFormat(
                  'MMMM d, y',
                ).format(previousIngredient.notificationDate);
                if (currentDateStr != previousDateStr) {
                  showHeader = true;
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 32.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Opacity(
                            opacity: 0.40,
                            child: Text(
                              'Date:',
                              style: TextStyle(
                                color: Color(0xFFFAFAFA),
                                fontSize: 12,
                                fontFamily: 'SF Compact Rounded',
                                fontWeight: FontWeight.w400,
                                height: 1.25,
                              ),
                            ),
                          ),
                          Text(
                            currentDateStr,
                            style: TextStyle(
                              color: Color(0xFF1DACD6),
                              fontSize: 12,
                              fontFamily: 'SF Compact Rounded',
                              fontWeight: FontWeight.w400,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 32.w,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditIngredient(
                                  ingredient: ingredient,
                                  index: index,
                                ),
                          ),
                        );
                      },
                      child: IngredientCardBakeBudget(
                        ingredient: ingredient,
                        index: index,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.w),
        child: SizedBox(
          width: 311,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddIngredientScreen(),
                ),
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
      ),
    );
  }
}
