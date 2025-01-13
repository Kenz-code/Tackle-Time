import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MoonPhaseLogic {
  String generateAuthString(String applicationId, String applicationSecret) {
    final credentials = '$applicationId:$applicationSecret';
    return base64.encode(utf8.encode(credentials));
  }

  Future<List<MoonPhase>> getMoonPhases({required DateTime fromDate, required DateTime toDate, required String longitude, required String latitude}) async {
    final appId = '8788326d-8078-4635-a14a-4f9c4d00f3d2';
    final appSecret = "9f531767d7f3564556586d45c9b38bb57273239137b1d3a7ac9ca5df9861ea659a602f4dfd03c07bd330d672c12c58a99010f5b00fcfb14ef9be8a9e385fe7ab54d73492007df3353a1ea345f7d97aa35d62ff05aaf80f31b0703d6ea06645f7649b8133e5ddfb39bafcd7867ecff155";

    final authString = generateAuthString(appId, appSecret);

    final url = "https://api.astronomyapi.com/api/v2/bodies/positions?longitude=$longitude}&latitude=$latitude&elevation=1&from_date=${DateFormat('yyyy-MM-dd').format(fromDate)}&to_date=${DateFormat('yyyy-MM-dd').format(toDate)}&time=${Uri.encodeComponent(DateFormat('HH:mm:ss').format(DateTime.now()))}";  // Replace with your latitude/longitude

    final response = await http.get(
      Uri.parse(url),
      headers: { 'Authorization': "Basic $authString"},
    );


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List cells = data['data']["table"]['rows'][1]["cells"];  // Adjust based on the actual response structure
      List<MoonPhase> moonPhases = [];

      for (final cell in cells) {
        moonPhases.add(MoonPhase(date: DateTime.parse(cell["date"]), phase: convertMoonPhaseToScale(cell["extraInfo"]["phase"]["fraction"])));
      }

      return moonPhases;
    } else {
      throw Exception('Failed to fetch moon phase');
    }
  }

  int convertMoonPhaseToScale(String moonPhase) {
    // Assuming moonPhase is between 0.067 (New Moon) and 0.0 (Full Moon)
    // Convert it to a scale from 0 to 1
    int scale = ((0.067 - double.parse(moonPhase)) / 0.067 * 100).round();

    // Ensure that the scale is between 0 and 1
    return scale.clamp(0, 100);
  }
}

class MoonPhase {
  const MoonPhase({required this.date, required this.phase});

  final DateTime date;
  final int phase;
}