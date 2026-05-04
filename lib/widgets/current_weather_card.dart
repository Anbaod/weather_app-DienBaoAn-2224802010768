import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/screens/forecast_screen.dart';
import 'package:weather_app/widgets/weather_detail_card.dart';

class CurrentWeatherCard extends StatefulWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  State<CurrentWeatherCard> createState() => _CurrentWeatherCardState();
}

class _CurrentWeatherCardState extends State<CurrentWeatherCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          DateFormat.yMMMMEEEEd('vi').format(widget.weather.dateTime),
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),

        Image.network(
          "https://openweathermap.org/img/wn/${widget.weather.icon}@4x.png",
          height: 120,
        ),

        Text(
          '${widget.weather.temperature.round()}°',
          style: TextStyle(
            fontSize: 80,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          widget.weather.description,
          style: TextStyle(
            fontSize: 21,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Thấp: ${widget.weather.tempMin}°',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),

            SizedBox(width: 15),

            Text(
              'Cao: ${widget.weather.tempMax}°',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        SizedBox(width: 15),

        TextButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForecastScreen()),
            ),
          },
          child: Text(
            "Chi Tiết Hôm Nay",
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueAccent,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 45),

        Row(
          children: [
            Expanded(
              child: WeatherDetailsSection(
                title: "Gió",
                icon: Icons.wind_power,
                value: "${widget.weather.windSpeed} km/h",
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: WeatherDetailsSection(
                title: "Cảm Giác",
                icon: Icons.thermostat,
                value: "${widget.weather.feelsLike}°",
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: WeatherDetailsSection(
                title: "Độ Ẩm",
                icon: Icons.water_drop,
                value: "${widget.weather.humidity} %",
              ),
            ),
          ],
        ),
      ],
    );
  }
}