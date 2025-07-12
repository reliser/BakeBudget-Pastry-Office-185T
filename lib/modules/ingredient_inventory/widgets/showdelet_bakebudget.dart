import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showDeleteDialogBakeBudget(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoTheme(
        data: const CupertinoThemeData(brightness: Brightness.light),
        child: CupertinoAlertDialog(
          title: Text(
            "Delete ingredient",
            style: TextStyle(
              fontSize: 17.sp,
              color: Color(0xFF000000),
              fontFamily: 'SF Compact Rounded',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "Are you sure you want to remove this ingredient? This action cannot be canceled.",
            style: TextStyle(
              fontSize: 13.sp,
              color: Color(0xFF383838),
              fontFamily: 'SF Compact Rounded',
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xFF007AFF),
                  fontSize: 17.sp,
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Color(0xFF007AFF),
                  fontSize: 17.sp,
                  fontFamily: 'SF Compact Rounded',
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
