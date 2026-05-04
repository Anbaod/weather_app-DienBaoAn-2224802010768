import 'package:flutter/material.dart';

class WeatherUtils {
  static List<Color> getWeatherGradient(String? condition) {
    if (condition == null) return [Colors.blue, Colors.lightBlueAccent];

    switch (condition.toLowerCase()) {
      case 'clear':
        return [const Color(0xFFFFB74D), const Color(0xFFFFA726)];
      case 'clouds':
        return [const Color(0xFF90A4AE), const Color(0xFF607D8B)];

      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return [const Color(0xFF4FC3F7), const Color(0xFF0288D1)];
      default:
        return [Colors.blue, Colors.lightBlueAccent];
    }
  }

  static IconData getWeatherIcon(String? condition) {
    if (condition == null) return Icons.wb_cloudy;
    switch (condition.toLowerCase()) {
      case 'clear': return Icons.wb_sunny;
      case 'clouds': return Icons.cloud;
      case 'rain': return Icons.beach_access;
      case 'thunderstorm': return Icons.flash_on;
      default: return Icons.wb_cloudy;
    }
  }
}