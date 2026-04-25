class ApiConfig {
  static const String baseUrl = "https://api.openweathermap.org/data/2.5";

  static const String apiKey = "1cedfda23d518d1e99b181dfbf0b1eb3";

  static String currentWeather(String city) {
    return "$baseUrl/weather?q=$city&appid=$apiKey&units=metric";
  }

  static String forecast(String city) {
    return "$baseUrl/forecast?q=$city&appid=$apiKey&units=metric";
  }
}