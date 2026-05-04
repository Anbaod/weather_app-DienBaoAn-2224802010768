import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/widgets/current_weather_card.dart';
import 'package:weather_app/widgets/daily_forecast_card.dart';
import 'package:weather_app/widgets/error_widget.dart';
import 'package:weather_app/widgets/loading_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),

      appBar: AppBar(
        backgroundColor: const Color(0xFF101922),
        centerTitle: true,
        title: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            final weather = provider.currentWeather;

            if (weather == null) {
              return const Text(
                "Weather App",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: Colors.blueAccent),
                const SizedBox(width: 5),
                Text(
                  "${weather.cityName}, ${weather.country}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),

      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.state == WeatherState.loading) {
            return const LoadingShimmer();
          }

          if (provider.state == WeatherState.error) {
            return ErrorWidgetCustom(
              message: provider.errorMessage,
              onRetry: () => provider.fetchWeatherByLocation(),
            );
          }

          if (provider.currentWeather == null) {
            return const Center(
              child: Text(
                'Chưa có dữ liệu',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<WeatherProvider>().refreshWeather(),

            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),

              children: [
                CurrentWeatherCard(weather: provider.currentWeather!),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Dự Báo 5 Ngày Tới",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                ...provider.dailyForecasts.map((dayWeather) {
                  return DailyForecastCard(weather: dayWeather);
                }).toList(),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}