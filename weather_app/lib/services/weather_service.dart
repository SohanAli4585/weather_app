import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import 'dart:io'; // SocketException ধরার জন্য

// ===== JSON parsing function for background thread =====
List<Forecast> parseForecast(String responseBody) {
  final data = jsonDecode(responseBody)['list'] as List;
  return data.map((e) => Forecast.fromJson(e)).toList();
}

class WeatherService {
  final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  // ===== Location-based current weather =====
  Future<Weather> getWeatherByLocation(double lat, double lon) async {
    if (apiKey.isEmpty) throw Exception('API key not found');

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else if (response.statusCode == 404) {
        throw Exception('Weather not found for your location');
      } else {
        throw Exception(
          'Failed to load weather. Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== Location-based 7-day forecast =====
  Future<List<Forecast>> get7DayForecastByLocation(
    double lat,
    double lon,
  ) async {
    if (apiKey.isEmpty) throw Exception('API key not found');

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return await compute(parseForecast, response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else if (response.statusCode == 404) {
        throw Exception('Forecast not found for your location');
      } else {
        throw Exception(
          'Failed to load forecast. Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== City-based current weather =====
  Future<Weather> getCurrentWeather(String city) async {
    if (city.isEmpty) throw Exception('City name cannot be empty');
    if (apiKey.isEmpty) throw Exception('API key not found');

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception(
          'Failed to load weather. Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== City-based 7-day forecast =====
  Future<List<Forecast>> get7DayForecast(String city) async {
    if (city.isEmpty) throw Exception('City name cannot be empty');
    if (apiKey.isEmpty) throw Exception('API key not found');

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return await compute(parseForecast, response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception(
          'Failed to load forecast. Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
