import 'package:apphud/apphud.dart';
import 'package:bakebudget_pastry_office_185t/app/app.dart';
import 'package:bakebudget_pastry_office_185t/bakebudget_notificationservice.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/models/equipment_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/equipment_log/models/equipment_spend.dart';
import 'package:bakebudget_pastry_office_185t/modules/ingredient_inventory/models/ingredient_model.dart';
import 'package:bakebudget_pastry_office_185t/modules/sales_revenue/models/sale_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

void webBakeBudgetPrem(BuildContext context, String llSaddlYUjkddsdsd) async {
  final Uri urlSaddlYUjkddsdsd = Uri.parse(llSaddlYUjkddsdsd);
  if (!await launchUrl(urlSaddlYUjkddsdsd)) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(llSaddlYUjkddsdsd)));
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final notificationService = BakebudgetNotificationService();
  await notificationService.initBakebudget();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(IngredientAdapter());
  Hive.registerAdapter(EquipmentAdapter());
  Hive.registerAdapter(EquipmentSpendAdapter());
  Hive.registerAdapter(SaleAdapter());

  await Hive.openBox<Ingredient>('ingredients');
  await Hive.openBox<Equipment>('equipmentBox');
  await Hive.openBox<EquipmentSpend>('equipmentSpendBox');
  await Hive.openBox<Sale>('salesBox');

  runApp(const MyAppBakeBudget());
  SharedPreferences ssmBakreJJkjdsssdd = await SharedPreferences.getInstance();
  bool qqkBakreJJkjdsssdd =
      ssmBakreJJkjdsssdd.getBool('vvfeyBakreJJkjdsssdd') ?? true;

  if (qqkBakreJJkjdsssdd) {
    await Future.delayed(const Duration(seconds: 15));
    try {
      final InAppReview inABakreJJkjdsssddee = InAppReview.instance;

      if (await inABakreJJkjdsssddee.isAvailable()) {
        inABakreJJkjdsssddee.requestReview();
      }
    } catch (e) {
      throw Exception(e);
    }
    await ssmBakreJJkjdsssdd.setBool('vvfeyBakreJJkjdsssdd', false);
  }

  await Apphud.start(apiKey: 'app_WZX5mkbzzBeKuz6pV7q1MLJnbeTstk');
}
