import 'dart:convert';

import 'package:fishing_calendar/utils/services/city_reader.dart';
import 'package:fishing_calendar/utils/services/json_convert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedCitiesManager {
  static const String _savedCitiesKey = 'saved_cities';
  static const String _selectedCityKey = 'selected_city';

  static final City pretendCity = City(
    "Vancouver (default)",
    49.2827,
    -123.1207,
    "CA",
    "America/Vancouver"
  );

  /// Save a list of cities to persistent storage
  Future<void> saveCities(List<City> cities) async {
    final prefs = await SharedPreferences.getInstance();

    List mapCities = [];
    for (City city in cities) {
      mapCities.add(city.toMap());
    }

    List<String> jsonCities = [];
    for (Map<String, dynamic> mapCity in mapCities) {
      jsonCities.add(JsonConverter.mapToJson(mapCity));
    }

    await prefs.setStringList(_savedCitiesKey, jsonCities);
  }

  /// Load a list of saved cities from persistent storage
  Future<List<City>> loadCities() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_savedCitiesKey) == false) {
      return [];
    }

    if (prefs.getStringList(_savedCitiesKey) == null) {
      return [];
    }

    List mapCities = [];
    for (String jsonCity in prefs.getStringList(_savedCitiesKey)!) {
      mapCities.add(JsonConverter.jsonToMap(jsonCity));
    }

    List<City> cities = [];
    for (final mapCity in mapCities) {
      cities.add(City.fromMap(mapCity));
    }

    return cities;
  }

  Future<void> saveCitiesAsJSON(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_savedCitiesKey, cities);
  }

  Future<List<String>> loadCitiesAsJSON() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_savedCitiesKey) ?? [];
  }

  /// Save the currently selected city
  Future<void> saveSelectedCity(City city) async {
    final prefs = await SharedPreferences.getInstance();

    final String jsonCity = JsonConverter.mapToJson(city.toMap());

    await prefs.setString(_selectedCityKey, jsonCity);
  }

  Future<void> resetSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();

    final cities = await loadCities();

    late City city;
    if (cities.isNotEmpty) {
      city = cities.first;
    } else {
      city = pretendCity;
    }

    final String jsonCity = JsonConverter.mapToJson(city.toMap());

    await prefs.setString(_selectedCityKey, jsonCity);
  }

  /// Load the currently selected city
  Future<City> loadSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_selectedCityKey) == false) {
      return pretendCity;
    }

    if (prefs.getString(_selectedCityKey) == null) {
      return pretendCity;
    }

    final String jsonCity = prefs.getString(_selectedCityKey)!;
    final Map<String, dynamic> mapCity = JsonConverter.jsonToMap(jsonCity);

    return City.fromMap(mapCity);
  }

  /// Add a new city to the list of saved cities
  Future<void> addCity(City city) async {
    final String jsonCity = JsonConverter.mapToJson(city.toMap());

    final cities = await loadCitiesAsJSON();
    if (!cities.contains(jsonCity)) {
      cities.add(jsonCity);
      await saveCitiesAsJSON(cities);
    }
  }

  /// Remove a city from the list of saved cities
  Future<void> removeCity(City city) async {
    final cities = await loadCities();
    cities.removeWhere((c) => c.name == city.name);
    await saveCities(cities);
  }

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
