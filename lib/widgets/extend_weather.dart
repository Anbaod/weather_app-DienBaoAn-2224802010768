import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/widgets/weather_detail_card.dart';

class ExtendWeatherCard extends StatefulWidget {
  final WeatherModel weather;

  const ExtendWeatherCard({super.key, required this.weather});

  @override
  State<ExtendWeatherCard> createState() => _ExtendWeatherCardState();
}

class _ExtendWeatherCardState extends State<ExtendWeatherCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: WeatherDetailsSection(
            title: "UV",
            icon: Icons.brightness_high,
            value: "${widget.weather.uvi}",
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: WeatherDetailsSection(
            title: "Bình Minh",
            icon: Icons.sunny_snowing,
            value: widget.weather.formatTime(widget.weather.sunrise),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: WeatherDetailsSection(
            title: "Hoàng Hôn",
            icon: Icons.wb_twilight,
            value: widget.weather.formatTime(widget.weather.sunset),
          ),
        ),
      ],
    );
  }
}