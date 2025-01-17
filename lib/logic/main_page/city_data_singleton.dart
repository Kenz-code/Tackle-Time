import 'package:tackle_time/utils/services/city_reader.dart';

class CityDataSingleton {
  static final CityDataSingleton _instance = CityDataSingleton._internal();
  factory CityDataSingleton() => _instance;

  CityDataSingleton._internal();

  List<City>? _cities;

  Future<void> loadCities(String filePath) async {
    _cities = await loadCitiesCompute(filePath);
  }

  List<City>? get cities => _cities;
}