import 'dart:io';

class NetworkTester {
  static Future<bool> checkInternetConnection() async {
    try {
      // Perform a DNS lookup for google.com
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("Internet Connection Available");
        return true;
      }
    } on SocketException catch (_) {
      print("No Internet Connection");
    }
    return false;
  }
}
