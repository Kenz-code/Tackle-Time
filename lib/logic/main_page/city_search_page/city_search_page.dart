import 'package:tackle_time/logic/main_page/city_data_singleton.dart';
import 'package:tackle_time/utils/services/city_reader.dart';
import 'package:flutter/material.dart';

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({Key? key}) : super(key: key);

  @override
  _CitySearchPageState createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<City> _filteredCities = [];
  List<City> cities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCities);
    getCities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCities() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredCities = cities
          .where((city) => city.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onCitySelected(City city) {
    // Handle city selection (e.g., print coordinates or navigate to another page)
    Navigator.of(context).pop(city);
  }

  Future<void> getCities() async {
    await CityDataSingleton().loadCities('assets/CA/CA.txt');

    setState(() {
      cities = CityDataSingleton().cities!;

      _filteredCities = cities;

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search City',
                  prefixIcon: const Icon(Icons.search),
                ),
              )
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text("Loading Cities..."),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCities.length,
                itemBuilder: (context, index) {
                  final city = _filteredCities[index];
                  return ListTile(
                    title: Text('${city.name} (${city.countryCode})'),
                    subtitle: Text('Lat: ${city.latitude}, Lon: ${city.longitude}, ${city.timeZoneId}'),
                    onTap: () => _onCitySelected(city),
                  );
                },
              ),
            ),

        ],
      ),
    );
  }
}
