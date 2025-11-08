import 'package:flutter/material.dart';
import '../models/forecast.dart';
import '../utils/helpers.dart';
import 'package:intl/intl.dart';

class DailyForecastList extends StatelessWidget {
  final List<Forecast> forecasts;

  const DailyForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: forecasts.map((f) {
        return ListTile(
          leading: Text(DateFormat.E().format(f.date), style: TextStyle(color: Colors.white)),
          title: Image.asset(getWeatherIconPath(f.icon), width: 30, height: 30),
          trailing: Text('${f.temp.toStringAsFixed(1)}°C', style: TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }
}
