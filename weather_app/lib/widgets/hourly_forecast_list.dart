import 'package:flutter/material.dart';
import '../models/forecast.dart';
import '../utils/helpers.dart';

class HourlyForecastList extends StatelessWidget {
  final List<Forecast> forecasts;

  const HourlyForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          final f = forecasts[index];
          return Container(
            width: 80,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${f.date.hour}:00', style: TextStyle(color: Colors.white)),
                Image.asset(getWeatherIconPath(f.icon), width: 40, height: 40),
                Text('${f.temp.toStringAsFixed(1)}°C', style: TextStyle(color: Colors.white)),
              ],
            ),
          );
        },
      ),
    );
  }
}
