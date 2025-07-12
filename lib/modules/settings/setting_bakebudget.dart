import 'package:bakebudget_pastry_office_185t/bakebudget_notificationservice.dart';
import 'package:bakebudget_pastry_office_185t/bakebudget_prem.dart';
import 'package:bakebudget_pastry_office_185t/main.dart';
import 'package:bakebudget_pastry_office_185t/modules/onboarding/preium_bakebudget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreenBakeBudget extends StatefulWidget {
  const SettingsScreenBakeBudget({super.key});

  @override
  State<SettingsScreenBakeBudget> createState() =>
      _SettingsScreenBakeBudgetState();
}

class _SettingsScreenBakeBudgetState extends State<SettingsScreenBakeBudget> {
  bool notificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationStateBakeBudget();
  }

  Future<void> _loadNotificationStateBakeBudget() async {
    bool isEnabled =
        await BakebudgetNotificationService()
            .areNotificationsEnabledBakeBudget();
    setState(() {
      notificationEnabled = isEnabled;
    });
  }

  Future<void> _handleNotificationToggleBakeBudget(bool value) async {
    if (value) {
      bool granted = await BakebudgetNotificationService().requestPermission();
      if (!granted) {
        // ignore: use_build_context_synchronously
        _showPermissionDialogBakeBudget(context);
        return;
      }
    }
    await BakebudgetNotificationService().toggleNotificationsBakeBudget(value);
    setState(() {
      notificationEnabled = value;
    });
  }

  void _showPermissionDialogBakeBudget(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Access to Push Notifications has been denied",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Allow access in Settings. So you don't forget about an important payment’s",
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                "Cancel",
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 28,
            color: Color(0xFFFAFAFA),
            fontFamily: 'SF Compact Rounded',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color(0xff1E2025),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            16.verticalSpace,
            FutureBuilder(
              future: getBakeBudgetPrem(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                if (snapshot.hasData && snapshot.data == false) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreiumBakebudget(),
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/images/premium_settings.png",
                      width: 311.w,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF333439),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildSliderTile(
                      "assets/icons/setting1.svg",
                      "Notifications",
                    ),
                    const Divider(
                      color: Color(0xFF5C5D61),
                      thickness: 0.5,
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildListTile(
                      "assets/icons/setting2.svg",
                      "Privacy Policy",
                      () {
                        webBakeBudgetPrem(context, 'https://docs.google.com/document/d/1d_P_9AmcnJpn0J3ArrX7EnWZZs7ThPXsc3uRxaYHdG8/edit?usp=sharing');
                      },
                    ),
                    const Divider(
                      color: Color(0xFF5C5D61),
                      thickness: 0.5,
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildListTile(
                      "assets/icons/setting3.svg",
                      "Terms of Use",
                      () {
                        webBakeBudgetPrem(context, 'https://docs.google.com/document/d/1CJCsVPCh0flcL7BWdlE3q1Es2eiNhf4KKorC3-UTp5c/edit?usp=sharing');
                      },
                    ),
                    const Divider(
                      color: Color(0xFF5C5D61),
                      thickness: 0.5,
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildListTile("assets/icons/setting4.svg", "Support", () {
                      webBakeBudgetPrem(context, 'https://sites.google.com/view/asaimobiliarialda/support-form');
                    }),
                  ],
                ),
              ),
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildSliderTile(String iconPath, String title) {
    return ListTile(
      leading: SvgPicture.asset(iconPath, width: 24, height: 24),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Switch(
        value: notificationEnabled,
        activeColor: const Color(0xff0177FB),
        activeTrackColor: Colors.white,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey,
        onChanged: _handleNotificationToggleBakeBudget,
      ),
    );
  }

  Widget _buildListTile(String iconPath, String title, void Function()? onTap) {
    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        color: Colors.blue,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFFFAFAFA),
          fontFamily: 'SF Compact Rounded',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
