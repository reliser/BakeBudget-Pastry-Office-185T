import 'package:apphud/apphud.dart';
import 'package:bakebudget_pastry_office_185t/components/bottom_bar_bakebudget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getBakeBudgetPrem() async {
  final dkkGardenPrem = await SharedPreferences.getInstance();
  return dkkGardenPrem.getBool('kdsoplkfGardenPrem') ?? false;
}

Future<void> setBakeBudgetPrem() async {
  final dkkjdGardenPrem = await SharedPreferences.getInstance();
  dkkjdGardenPrem.setBool('kdsoplkfGardenPrem', true);
}

Future<void> restoreBakeBudgetPrem(BuildContext context) async {
  final dkkjdsooGardenPrem = await Apphud.hasPremiumAccess();
  final dk3dllooGardenPrem = await Apphud.hasActiveSubscription();
  if (dkkjdsooGardenPrem || dk3dllooGardenPrem) {
    final prefsGardenPrem = await SharedPreferences.getInstance();
    prefsGardenPrem.setBool("kdsoplkfGardenPrem", true);
    showDialog(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Success!'),
            content: const Text('Your purchase has been restored!'),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BottomBarPastryOfficeBakeBudget(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('Ok'),
              ),
            ],
          ),
    );
  } else {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Restore purchase'),
            content: const Text(
              'Your purchase is not found. Write to support: https://sites.google.com/view/asaimobiliarialda/support-form',
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => {Navigator.of(context).pop()},
                child: const Text('Ok'),
              ),
            ],
          ),
    );
  }
}
