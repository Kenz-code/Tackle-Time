import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherLogic {
  Future<List<WeatherCode>> getWeatherCodes({required DateTime fromDate, required DateTime toDate, required String longitude, required String latitude}) async {
    final url = "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=weather_code,temperature_2m_max,temperature_2m_min,uv_index_max,wind_speed_10m_max&timezone=auto&start_date=${DateFormat('yyyy-MM-dd').format(fromDate)}&end_date=${DateFormat('yyyy-MM-dd').format(toDate)}";

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final codes = data["daily"];  // Adjust based on the actual response structure
      List<WeatherCode> weatherCodes = [];


      for (var i = 0; i < codes["time"].length; i++) {

        weatherCodes.add(WeatherCode(
          date: DateTime.parse(codes["time"][i]),
          code: codes["weather_code"][i],
          tempMax: codes['temperature_2m_max'][i],
          tempMin: codes['temperature_2m_min'][i],
          maxWind: codes["wind_speed_10m_max"][i],
          uvMax: codes["uv_index_max"][i]
        ));
      }

      return weatherCodes;
    } else {
      throw ArgumentError("Failed to get weather codes");
    }
  }
}

class WeatherCode {
  final DateTime date;
  final int code;
  final double tempMax;
  final double tempMin;
  final double maxWind;
  final double uvMax;

  WeatherCode({required this.date, required this.code, required this.tempMax, required this.tempMin, required this.maxWind, required this.uvMax});
}