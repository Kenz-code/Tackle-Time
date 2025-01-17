import 'package:shared_preferences/shared_preferences.dart';
import 'settings_model.dart';
import 'package:tackle_time/utils/services/unit_converter/unit_enums.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();

  factory SettingsService() {
    return _instance;
  }

  SettingsService._internal();

  SettingsModel _settings = SettingsModel.defaultSettings();

  SettingsModel get settings => _settings;

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temperatureUnitString = prefs.getString('temperatureUnit') ?? "C";
    String speedUnitString = prefs.getString('speedUnit') ?? "km/h";

    _settings = SettingsModel(
      temperatureUnit: TemperatureUnit.fromString(temperatureUnitString),
      speedUnit: SpeedUnit.fromString(speedUnitString),
    );
  }

  Future<void> saveSettings(SettingsModel newSettings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('temperatureUnit', newSettings.temperatureUnit.toString());
    await prefs.setString('speedUnit', newSettings.speedUnit.toString());

    _settings = newSettings;
  }

  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    await saveSettings(
      SettingsModel(
        temperatureUnit: unit,
        speedUnit: _settings.speedUnit,
      ),
    );
  }

  Future<void> setSpeedUnit(SpeedUnit unit) async {
    await saveSettings(
      SettingsModel(
        temperatureUnit: _settings.temperatureUnit,
        speedUnit: unit,
      ),
    );
  }
}
