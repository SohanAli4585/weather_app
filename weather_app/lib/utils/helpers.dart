import 'package:flutter/widgets.dart';

/// Returns the background image path based on the weather icon code.
String getWeatherBackground(String icon) {
  if (icon.contains('d')) {
    if (icon.startsWith('01')) {
      return 'assets/images/sunny_bg.jpg';
    } else if (icon.startsWith('02') ||
        icon.startsWith('03') ||
        icon.startsWith('04')) {
      return 'assets/images/cloudy_bg.jpg';
    } else if (icon.startsWith('09') || icon.startsWith('10')) {
      return 'assets/images/rainy_bg.jpg';
    }
  }

  // Default night background
  return 'assets/images/night_bg.png';
}

/// Returns the weather icon path based on the weather icon code.
String getWeatherIconPath(String icon) {
  if (icon.startsWith('01')) {
    return 'assets/icons/sun.png';
  } else if (icon.startsWith('02') ||
      icon.startsWith('03') ||
      icon.startsWith('04')) {
    return 'assets/icons/cloud.png';
  } else if (icon.startsWith('09') || icon.startsWith('10')) {
    return 'assets/icons/rain.png';
  }

  // Default icon
  return 'assets/icons/sun.png';
}

/// Precache images to avoid UI jank.
/// Call this in initState() of your HomeScreen.
Future<void> precacheWeatherImages(BuildContext context) async {
  const imagePaths = [
    'assets/images/sunny_bg.jpg',
    'assets/images/cloudy_bg.png',
    'assets/images/rainy_bg.jpg',
    'assets/images/night_bg.jpg',
    'assets/icons/sun.png',
    'assets/icons/cloud.png',
    'assets/icons/rain.png',
    'assets/icons/snow.png',
    'assets/icons/thunderstorm.png',
  ];

  for (var path in imagePaths) {
    await precacheImage(AssetImage(path), context);
  }
}
