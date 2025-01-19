import 'package:package_info_plus/package_info_plus.dart';
import 'package:tackle_time/domain/onboarding_check.dart';
import 'package:tackle_time/utils/constants/border_radius.dart';
import 'package:tackle_time/utils/services/onboarding_service.dart';
import 'package:tackle_time/presentation/onboarding/onboarding_page.dart';
import 'package:tackle_time/utils/services/settings/settings_service.dart';
import 'package:tackle_time/utils/services/unit_converter/unit_enums.dart';
import 'package:flutter/material.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool installPromptEnabled = false;

  String versionNumber = '';

  @override
  void initState() {
    super.initState();

    installPromptEnabled = PWAInstall().installPromptEnabled;

    // get version number
    getVersionNumber();
  }

  Future<void> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      versionNumber = packageInfo.version;
    });
  }


  void goToOnboardingPage(BuildContext context) async {
    await OnboardingService().resetOnboardingStatus();

    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingCheck()));
  }

  Future<void> changeTempUnit(String unit) async {
    await SettingsService().setTemperatureUnit(TemperatureUnit.fromString(unit));
    setState(() {});
  }

  Future<void> changeSpeedUnit(String unit) async {
    await SettingsService().setSpeedUnit(SpeedUnit.fromString(unit));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.thermostat_rounded),
            title: Text("Temperature unit: °${SettingsService().settings.temperatureUnit.toString()}"),
            trailing: PopupMenuButton(
              icon: Icon(Icons.arrow_drop_down_circle),
              shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.defaultBorderRadius),
              itemBuilder: (context) => [
                ...TemperatureUnit.toListOfStrings().map((unit) => PopupMenuItem(
                  value: unit,
                  child: Text("°$unit"),
                  onTap: () => changeTempUnit(unit),
                ))
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.speed_rounded),
            title: Text("Speed unit: ${SettingsService().settings.speedUnit.toString()}"),
            trailing: PopupMenuButton(
              icon: Icon(Icons.arrow_drop_down_circle),
              shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.defaultBorderRadius),
              itemBuilder: (context) => [
                ...SpeedUnit.toListOfStrings().map((unit) => PopupMenuItem(
                  value: unit,
                  child: Text("$unit"),
                  onTap: () => changeSpeedUnit(unit),
                ))
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.handshake_rounded),
            title: Text("Show onboarding page"),
            onTap: () => goToOnboardingPage(context),
          ),

          installPromptEnabled ?
          ListTile(
            leading: Icon(Icons.install_mobile_rounded),
            title: Text("Install app"),
            onTap: () {
              PWAInstall().promptInstall_();
            },
          ) : SizedBox.shrink(),

          ListTile(
            title: Text("Version number: $versionNumber", style: Theme.of(context).textTheme.bodyMedium,),
          ),
        ],
      ),
    );
  }
}
