class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = String.fromEnvironment('OPENWEATHER_API_KEY');

  // Endpoints
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String oneCall = '/onecall';

  // Build URL
  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse('$baseUrl$endpoint');
    params['appid'] = apiKey;
    params['units'] = 'metric'; // Sử dụng độ C
    return uri.replace(queryParameters: params).toString();
  }
}