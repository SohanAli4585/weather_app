import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../utils/helpers.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Weather weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(getWeatherBackground(weather.icon)),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(weather.cityName,
              style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              Image.asset(getWeatherIconPath(weather.icon), width: 60, height: 60),
              SizedBox(width: 10),
              Text('${weather.temperature.toStringAsFixed(1)}°C',
                  style: TextStyle(fontSize: 36, color: Colors.white)),
            ],
          ),
          SizedBox(height: 10),
          Text(weather.description,
              style: TextStyle(fontSize: 20, color: Colors.white)),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.opacity, color: Colors.white),
              SizedBox(width: 5),
              Text('${weather.humidity}%', style: TextStyle(color: Colors.white)),
              SizedBox(width: 20),
              Icon(Icons.air, color: Colors.white),
              SizedBox(width: 5),
              Text('${weather.windSpeed} m/s', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
