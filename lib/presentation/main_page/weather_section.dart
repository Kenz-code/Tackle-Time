import 'package:fishing_calendar/logic/main_page/selected_data_manager.dart';
import 'package:flutter/material.dart';

class WeatherSection extends StatelessWidget {
  const WeatherSection({super.key});

  String weatherCodeToName(int code) {
    switch (code) {
      case 0:
        return "Sunny";
      case 1:
      case 2:
        return "Partly Cloudy";
      case 3:
        return "Overcast";
      case 45:
      case 48:
        return "Fog";
      case 51:
      case 56:
      case 61:
      case 66:
      case 80:
        return "Light rain";
      case 53:
      case 55:
      case 57:
      case 63:
      case 65:
      case 67:
      case 81:
      case 82:
        return "Rain";
      case 71:
      case 77:
      case 85:
        return "Light Snow";
      case 73:
      case 75:
      case 86:
        return "Snow";
      case 95:
      case 96:
      case 99:
        return "Thunderstorm";
      default:
        return "Sunny";
    }
  }

  String weatherCodeToAssetPath(int code) {
    switch (code) {
      case 0:
        return "assets/weather_icons/Sun.png";
      case 1:
      case 2:
        return "assets/weather_icons/Partly Cloudy.png";
      case 3:
        return "assets/weather_icons/Cloud.png";
      case 45:
      case 48:
        return "assets/weather_icons/Fog.png";
      case 51:
      case 56:
      case 61:
      case 66:
      case 80:
        return "assets/weather_icons/Rain.png";
      case 53:
      case 55:
      case 57:
      case 63:
      case 65:
      case 67:
      case 81:
      case 82:
        return "assets/weather_icons/Heavy Rain.png";
      case 71:
      case 77:
      case 85:
        return "assets/weather_icons/Snow.png";
      case 73:
      case 75:
      case 86:
        return "assets/weather_icons/Heavy Snow.png";
      case 95:
      case 96:
      case 99:
        return "assets/weather_icons/Storm.png";
      default:
        return "assets/weather_icons/Sun.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map?>(
        valueListenable: SelectedDataManager().selectedDataNotifier,
        builder: (context, selectedData, _) {
          if (selectedData != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  // title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Daily Weather", style: Theme.of(context).textTheme.titleSmall),
                      Text(weatherCodeToName(selectedData['weatherData'].code)),
                    ],
                  ),

                  SizedBox(height: 16,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        weatherCodeToAssetPath(selectedData['weatherData'].code),
                        width: 100,
                        height: 100,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${selectedData['weatherData'].tempMax.round()}°C", style: Theme.of(context).textTheme.displaySmall,),

                          Text("${selectedData['weatherData'].tempMin.round()}°C", style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),),
                        ],
                      ),

                      Row(
                        children: [
                          Column(
                            children: [
                              Icon(Icons.air_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant,),
                              Image.asset(
                                "assets/weather_icons/ultraviolet.png",
                                width: 20,
                                height: 20,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("${selectedData['weatherData'].maxWind.round()} km/h", style: Theme.of(context).textTheme.titleMedium,),
                              SizedBox(height: 4,),
                              Text("${selectedData['weatherData'].uvMax.round()}", style: Theme.of(context).textTheme.titleMedium),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );

          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }
}
