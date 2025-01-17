import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class City {
  final String name;
  final double latitude;
  final double longitude;
  final String countryCode;
  final String timeZoneId; // Time zone ID (e.g., "America/Edmonton")

  City(this.name, this.latitude, this.longitude, this.countryCode, this.timeZoneId);

  @override
  String toString() =>
      '$name ($countryCode): ($latitude, $longitude), TimeZone: $timeZoneId';

  // Convert City object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'countryCode': countryCode,
      'timeZoneId': timeZoneId,
    };
  }

  // Create a City object from a Map
  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      map['name'] as String,
      map['latitude'] as double,
      map['longitude'] as double,
      map['countryCode'] as String,
      map['timeZoneId'] as String,
    );
  }
}

// Parse GeoNames file (top-level function for use with compute)
List<City> parseGeoNamesData(String data) {
  final cities = <City>[];

  // Split the data into lines
  final lines = const LineSplitter().convert(data);

  for (var line in lines) {
    final parts = line.split('\t'); // Tab-delimited
    if (parts.length > 17) {
      final featureClass = parts[6]; // Feature class field
      if (featureClass == 'P') { // Filter only cities and villages
        final name = parts[1]; // City name
        final latitude = double.tryParse(parts[4]) ?? 0.0;
        final longitude = double.tryParse(parts[5]) ?? 0.0;
        final countryCode = parts[8]; // Country code
        final timeZoneId = parts[17]; // Time zone ID

        cities.add(City(name, latitude, longitude, countryCode, timeZoneId));
      }
    }
  }

  return cities;
}

// Function to load and parse the GeoNames file
Future<List<City>> loadCitiesCompute(String assetPath) async {
  // Load the file as a string from assets
  final String data = await rootBundle.loadString(assetPath);

  // Parse the data on a background thread
  return await compute(parseGeoNamesData, data);
}