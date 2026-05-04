import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/widgets/current_weather_card.dart';
import 'package:weather_app/widgets/error_widget.dart';
import 'package:weather_app/widgets/extend_weather.dart';
import 'package:weather_app/widgets/loading_shimmer.dart';
import 'package:weather_app/widgets/hourly_forcast_list.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),

      appBar: AppBar(
        backgroundColor: const Color(0xFF101922),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
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

      body: RefreshIndicator(
        onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
        child: Consumer<WeatherProvider>(
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

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CurrentWeatherCard(
                        weather: provider.currentWeather!,
                      ),
                      const SizedBox(height: 25),
                      ExtendWeatherCard(
                        weather: provider.currentWeather!,
                      ),
                      const SizedBox(height: 25),
                      HourlyForecastList(
                        hourlyForecasts: provider.hourlyForecasts,
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Dự báo 5 ngày",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),
                      ...provider.dailyForecasts.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('EEEE', 'vi_VN')
                                    .format(item.dateTime),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                item.description,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "${item.tempMax.round()}° / ${item.tempMin.round()}°",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}