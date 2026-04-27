import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Thêm package này
import 'providers/weather_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  // Bắt buộc phải có dòng này khi hàm main là async
  WidgetsFlutterBinding.ensureInitialized();

  // Tải API Key từ file .env
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      // Tạm thời giữ nguyên, chúng ta sẽ truyền thêm LocationService và StorageService vào đây sau
      create: (_) => WeatherProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: HomeScreen(),
    );
  }
}