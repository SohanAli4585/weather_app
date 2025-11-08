import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/screens/city_search_screen.dart';
import 'package:weather_app/screens/settings_screen.dart';
import '../services/weather_service.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_list.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final WeatherService _service = WeatherService();
  Weather? _weather;
  List<Forecast> _forecasts = [];
  bool _isLoading = true;
  String? _error;

  // Background fade animation
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String _backgroundImage = 'assets/images/night_bg.jpg'; // Initial background

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    Future.microtask(() => precacheWeatherImages(context));
    Future.microtask(() => _loadWeatherByLocation());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ===== GPS-based weather loader =====
  Future<void> _loadWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 1. Get current position
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 2. Get weather by location
      final w = await _service.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      final f = await _service.get7DayForecastByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _weather = w;
        _forecasts = f;
        _backgroundImage = getWeatherBackground(w.icon);
      });

      _controller.reset();
      _controller.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ===== City search loader =====
  Future<void> _loadWeatherByCity(String city) async {
    setState(() => _isLoading = true);
    try {
      final w = await _service.getCurrentWeather(city);
      final f = await _service.get7DayForecast(city);
      setState(() {
        _weather = w;
        _forecasts = f;
        _backgroundImage = getWeatherBackground(w.icon);
      });
      _controller.reset();
      _controller.forward();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with fade animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              _backgroundImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/night_bg.jpg', // fallback image
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Weather App',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CitySearchScreen(),
                                ),
                              );
                              if (result != null) {
                                await _loadWeatherByCity(result);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Main content
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : _error != null
                      ? Center(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_weather != null)
                                CurrentWeatherCard(weather: _weather!),
                              const SizedBox(height: 20),
                              const Text(
                                'Hourly Forecast',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              HourlyForecastList(forecasts: _forecasts),
                              const SizedBox(height: 20),
                              const Text(
                                'Daily Forecast',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              DailyForecastList(forecasts: _forecasts),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
