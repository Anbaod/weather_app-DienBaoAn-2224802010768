import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101922),
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.settings, color: Colors.blueAccent),
              const SizedBox(width: 5),
              Text(
                "Cài Đặt Đơn Vị Đo",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text(
                  "Đơn vị đo độ C (°C)",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  provider.isCelsius ? "Đang dùng độ C" : "Đang dùng độ F",
                  style: const TextStyle(color: Colors.white54),
                ),
                value: provider.isCelsius,
                activeThumbColor: Colors.blueAccent,
                onChanged: (bool value) {
                  provider.toggleUnit();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}