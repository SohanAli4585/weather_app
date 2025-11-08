class Forecast {
  final DateTime date;
  final double temp;
  final String icon;

  Forecast({required this.date, required this.temp, required this.icon});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: json['main']['temp'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}
