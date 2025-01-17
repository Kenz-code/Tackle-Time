enum TemperatureUnit {
  celsius,
  fahrenheit;

  @override
  String toString() {
    switch (this) {
      case TemperatureUnit.celsius:
        return "C";
      case TemperatureUnit.fahrenheit:
        return "F";
    }
  }

  // Convert string to TemperatureUnit
  static TemperatureUnit fromString(String value) {
    switch (value) {
      case "C":
        return TemperatureUnit.celsius;
      case "F":
        return TemperatureUnit.fahrenheit;
      default:
        throw ArgumentError("Invalid temperature unit: $value");
    }
  }

  // Convert enum values to a list of strings
  static List<String> toListOfStrings() {
    return TemperatureUnit.values.map((unit) => unit.toString()).toList();
  }
}

enum SpeedUnit {
  kilometersPerHour,
  milesPerHour;

  @override
  String toString() {
    switch (this) {
      case SpeedUnit.kilometersPerHour:
        return "km/h";
      case SpeedUnit.milesPerHour:
        return "mph";
    }
  }

  // Convert string to SpeedUnit
  static SpeedUnit fromString(String value) {
    switch (value) {
      case "km/h":
        return SpeedUnit.kilometersPerHour;
      case "mph":
        return SpeedUnit.milesPerHour;
      default:
        throw ArgumentError("Invalid speed unit: $value");
    }
  }

  // Convert enum values to a list of strings
  static List<String> toListOfStrings() {
    return SpeedUnit.values.map((unit) => unit.toString()).toList();
  }
}
