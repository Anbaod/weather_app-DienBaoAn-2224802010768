import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/providers/weather_provider.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> hourlyForecasts;

  const HourlyForecastList({super.key, required this.hourlyForecasts});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Dự báo theo giờ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyForecasts.length > 8 ? 8 : hourlyForecasts.length,
            itemBuilder: (context, index) {
              final forecast = hourlyForecasts[index];
              final time = DateFormat('HH:mm').format(forecast.dateTime);
              final temp = provider.getTemperature(forecast.temperature);

              return Container(
                width: 70,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1c2632),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Image.network(
                      'https://openweathermap.org/img/wn/${forecast.icon}.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${temp.round()}${provider.unitSymbol}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}