import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showDatePickerDialogBakeBudget(
  BuildContext context,
  DateTime currentDate,
  Function(DateTime) onDateSelected,
) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) {
      return CupertinoTheme(
        data: const CupertinoThemeData(brightness: Brightness.light),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 245,
                          child: CupertinoDatePicker(
                            backgroundColor: Colors.transparent,
                            initialDateTime: currentDate,
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime newDate) {
                              onDateSelected(newDate);
                            },
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
                        CupertinoButton(
                          child: const Text(
                            'Select',
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF007AFF),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
