import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';

class WeatherService {

  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {'q': cityName},
      );

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy thành phố');
      } else {
        throw Exception('Lỗi lấy dữ liệu thời tiết');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates(
      double lat,
      double lon,
      ) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {
          'lat': lat,
          'lon': lon,
        },
      );

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Không thể lấy thời tiết theo vị trí');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<List<ForecastModel>> getForecast({
    String? cityName,
    double? lat,
    double? lon,
  }) async {
    try {
      Map<String, dynamic> params = {};

      if (cityName != null) {
        params = {'q': cityName};
      } else if (lat != null && lon != null) {
        params = {
          'lat': lat,
          'lon': lon,
        };
      } else {
        throw Exception('Thiếu tham số cityName hoặc lat/lon');
      }

      final url = ApiConfig.buildUrl(
        ApiConfig.forecast,
        params,
      );

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'];

        return forecastList
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Không thể lấy dữ liệu forecast');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }
}