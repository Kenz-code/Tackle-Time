import 'package:tackle_time/presentation/main_page/sections/daily_activity_section.dart';
import 'package:tackle_time/presentation/main_page/settings/settings_page.dart';
import 'package:tackle_time/presentation/main_page/sections/weather_section.dart';
import 'package:tackle_time/utils/services/city_reader.dart';
import 'package:tackle_time/utils/services/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:tackle_time/utils/services/saved_cities.dart';
import 'package:tackle_time/utils/constants/border_radius.dart';
import 'package:tackle_time/presentation/main_page/sections/calendar_grid.dart';
import 'package:tackle_time/logic/main_page/city_search_page/city_search_page.dart';
import 'package:tackle_time/logic/main_page/moon_phase.dart';
import 'package:tackle_time/logic/main_page/weather_logic.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MoonPhaseLogic _moonPhaseLogic = MoonPhaseLogic();
  final WeatherLogic _weatherLogic = WeatherLogic();
  final SavedCitiesManager _savedCitiesManager = SavedCitiesManager();

  List<City> _savedCities = [];
  City? _selectedCity;
  Map<String, dynamic>? _fishingData;

  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  List<Widget> content = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!(_isScrolled == _scrollController.offset > 0)) {
      setState(() {
        _isScrolled = _scrollController.offset > 0;
      });
    }
  }

  Future<void> _loadInitialData() async {
    final savedCities = await _savedCitiesManager.loadCities();
    final selectedCity = await _savedCitiesManager.loadSelectedCity();

    final fishingData = await _fetchFishingData(selectedCity);
    setState(() {
      _savedCities = savedCities;
      _selectedCity = selectedCity;
      _fishingData = fishingData;
    });

    // load settings
    await SettingsService().loadSettings();
  }

  Future<Map<String, dynamic>> _fetchFishingData(City city) async {
    final moonPhaseData = await _moonPhaseLogic.getMoonPhases(
      fromDate: DateTime.now().subtract(Duration(days: 31)),
      toDate: DateTime.now().add(Duration(days: 14)),
      latitude: city.latitude.toString(),
      longitude: city.longitude.toString(),
    );
    final weatherData = await _weatherLogic.getWeatherCodes(
      fromDate: DateTime.now().subtract(Duration(days: 31)),
      toDate: DateTime.now().add(Duration(days: 14)),
      latitude: city.latitude.toString(),
      longitude: city.longitude.toString(),
    );
    return {'moonPhaseData': moonPhaseData, 'weatherData': weatherData};
  }

  Future<void> _onAddNewCity(BuildContext context) async {
    final City? newCity = await Navigator.push(context, MaterialPageRoute(builder: (context) => CitySearchPage()));
    if (newCity != null) {
      setState(() {
        _selectedCity = null;
      });

      await _savedCitiesManager.addCity(newCity);
      await _savedCitiesManager.saveSelectedCity(newCity);
      await _loadInitialData();
    }
  }

  Future<void> _onRemoveCity(City city) async {
    await _savedCitiesManager.removeCity(city);
    bool reset = false;

    if (_selectedCity!.name == city.name) {
      reset = true;
    }

    setState(() {
      _selectedCity = null;
    });

    if (reset) {
      await _savedCitiesManager.resetSelectedCity();
    }

    await _loadInitialData();
  }

  Future<void> _onCitySelected(City city) async {
    setState(() {
      _selectedCity = null;
    });
    await _savedCitiesManager.saveSelectedCity(city);

    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCity == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    content = [
      if (_fishingData != null) CalendarGrid(_fishingData!),
      Divider(height: 32),
      if (_fishingData != null) DailyActivitySection(selectedCity: _selectedCity!,),
      Divider(height: 32),
      if (_fishingData != null) WeatherSection(),
      Divider(height: 32,),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(child: Text("Copyright (c) 2025 KenboDev"))
      ),
      SizedBox(height: 16,),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: _isScrolled ? Theme.of(context).colorScheme.surfaceTint : Colors.transparent,
        title: Text(_selectedCity?.name ?? "Select a City"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              setState(() {});
            },
            icon: Icon(Icons.settings_rounded),
          ),

          PopupMenuButton(
            icon: Icon(Icons.arrow_drop_down_circle),
            shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.defaultBorderRadius),
            itemBuilder: (context) => [
              ..._savedCities.map((city) => PopupMenuItem(
                value: city,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(city.name),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _onRemoveCity(city);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                onTap: () => _onCitySelected(city),
              )),
              PopupMenuItem(
                child: Row(
                  children: [Icon(Icons.add), SizedBox(width: 8), Text("Add City")],
                ),
                onTap: () => _onAddNewCity(context),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.surfaceDim, Theme.of(context).colorScheme.surface],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          ListView.builder(
            controller: _scrollController,
            itemCount: content.length,
            itemBuilder: (context, index) => content[index]
          ),
        ],
      ),
    );
  }
}
