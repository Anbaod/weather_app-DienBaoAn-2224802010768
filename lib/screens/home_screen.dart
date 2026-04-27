import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_utils.dart';
import '../widgets/weather_detail_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tự động lấy vị trí hiện tại khi vào app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          final weather = provider.currentWeather;
          final gradient = WeatherUtils.getWeatherGradient(weather?.mainCondition);

          return Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: gradient, begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => provider.refreshWeather(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildSearchBox(provider),
                      if (provider.state == WeatherState.loading)
                        const Padding(padding: EdgeInsets.only(top: 50), child: CircularProgressIndicator(color: Colors.white)),

                      if (provider.state == WeatherState.error)
                        _buildErrorView(provider.errorMessage),

                      if (weather != null && provider.state == WeatherState.loaded)
                        _buildWeatherInfo(weather, provider),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBox(WeatherProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        controller: _cityController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Tìm thành phố...",
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () => provider.fetchWeatherByLocation(),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
        onSubmitted: (value) => provider.fetchWeatherByCity(value),
      ),
    );
  }

  Widget _buildWeatherInfo(weather, provider) {
    return Column(
      children: [
        Text(weather.cityName, style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
        Text(DateFormat('EEEE, d MMMM').format(DateTime.now()), style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 20),
        CachedNetworkImage(
          imageUrl: "https://openweathermap.org/img/wn/${weather.icon}@4x.png",
          height: 150,
        ),
        Text("${weather.temperature.round()}°C", style: const TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.w200)),
        Text(weather.description.toUpperCase(), style: const TextStyle(fontSize: 18, color: Colors.white, letterSpacing: 2)),
        const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            WeatherDetailCard(label: "Độ ẩm", value: "${weather.humidity}%", icon: Icons.water_drop),
            WeatherDetailCard(label: "Gió", value: "${weather.windSpeed} km/h", icon: Icons.air),
            WeatherDetailCard(label: "Áp suất", value: "${weather.pressure} hPa", icon: Icons.speed),
          ],
        ),

        const SizedBox(height: 30),
        const Align(alignment: Alignment.centerLeft, child: Text("Dự báo 5 ngày", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
        const SizedBox(height: 15),
        _buildForecastList(provider.forecast),
      ],
    );
  }

  Widget _buildForecastList(List forecast) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.length,
        itemBuilder: (context, index) {
          final f = forecast[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DateFormat('E, HH:mm').format(f.dateTime), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Image.network("https://openweathermap.org/img/wn/${f.icon}.png", width: 50),
                Text("${f.temperature.round()}°C", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 60),
          const SizedBox(height: 10),
          Text(error, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}