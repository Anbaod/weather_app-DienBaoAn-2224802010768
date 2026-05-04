import 'package:flutter/material.dart';

class WeatherDetailsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;

  const WeatherDetailsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1c2632),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}