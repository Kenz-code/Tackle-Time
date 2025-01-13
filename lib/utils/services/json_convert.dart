import 'dart:convert';

class JsonConverter {
  /// Converts a Map to a JSON string.
  static String mapToJson(Map<String, dynamic> map) {
    return jsonEncode(map);
  }

  /// Converts a JSON string to a Map.
  static Map<String, dynamic> jsonToMap(String jsonString) {
    return jsonDecode(jsonString);
  }
}
