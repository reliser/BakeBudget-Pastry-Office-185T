import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BakebudgetNotificationService {
  static final BakebudgetNotificationService _notificationService =
      BakebudgetNotificationService._internal();
  factory BakebudgetNotificationService() => _notificationService;
  BakebudgetNotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  static const String _notificationsEnabledKey = 'notifications_enabled';

  Future<void> initBakebudget() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(iOS: iosInit);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_notificationsEnabledKey)) {
      await prefs.setBool(_notificationsEnabledKey, false);
    }

    _isInitialized = true;
  }

  Future<bool> requestPermission() async {
    final bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    final isEnabled = result ?? false;
    return isEnabled;
  }

  Future<void> scheduleNotification({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
  }) async {
    if (!await areNotificationsEnabledBakeBudget()) return;

    final scheduleTime = tz.TZDateTime.from(dateTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'reminders_channel_id',
      'Reminders',
      channelDescription: 'Channel for reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancelNotificationBakeBudget(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _saveNotificationStateBakeBudget(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, isEnabled);
  }

  Future<bool> areNotificationsEnabledBakeBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(_notificationsEnabledKey) ?? false;
    return isEnabled;
  }

  Future<void> toggleNotificationsBakeBudget(bool enable) async {
    await _saveNotificationStateBakeBudget(enable);

    if (!enable) {
      await cancelAllNotifications();
    }
  }

  Future<void> openAppSettingsBakeBudget() async {
    const url = 'app-settings:';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
