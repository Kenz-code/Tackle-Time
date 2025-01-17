import 'package:tackle_time/utils/services/unit_converter/unit_enums.dart';

class SettingsModel {
  TemperatureUnit temperatureUnit;
  SpeedUnit speedUnit;

  SettingsModel({
    required this.temperatureUnit,
    required this.speedUnit,
  });

  // Factory method to create default settings
  factory SettingsModel.defaultSettings() {
    return SettingsModel(
      temperatureUnit: TemperatureUnit.celsius,
      speedUnit: SpeedUnit.kilometersPerHour,
    );
  }
}
