class UnitConverter {
  // Convert Celsius to Fahrenheit
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  // Convert Fahrenheit to Celsius
  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  // Convert km/h to mph
  static double kilometersPerHourToMilesPerHour(double kmh) {
    return kmh * 0.621371;
  }

  // Convert mph to km/h
  static double milesPerHourToKilometersPerHour(double mph) {
    return mph / 0.621371;
  }
}
