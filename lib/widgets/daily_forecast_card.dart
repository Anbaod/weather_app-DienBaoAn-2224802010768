import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Cần import intl
import 'package:weather_app/models/forecast_model.dart';

class DailyForecastCard extends StatelessWidget {
  final ForecastModel weather;

  const DailyForecastCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = DateFormat('EEEE', 'vi').format(weather.dateTime);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1c2632),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            child: Text(
                dayOfWeek,
                style: const TextStyle(color: Colors.white, fontSize: 16)
            ),
          ),

          Image.network(
            'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
            width: 40,
            height: 40,
            errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.white),
          ),

          Expanded(
            child: Text(
              weather.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Text(
            "${weather.temperature.round()}°",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}