import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/storage_service.dart';
import 'package:weather_app/services/weather_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;

  WeatherModel? _currentWeather;
  List<ForecastModel> _fullForecast = [];
  List<ForecastModel> _dailyForecast = [];
  List<ForecastModel> get hourlyForecasts => _fullForecast;

  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';

  WeatherProvider(
      this._weatherService,
      this._locationService,
      this._storageService,
      );

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get dailyForecasts => _dailyForecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;

  void _processDailyForecast() {
    _dailyForecast = [];
    final Set<String> processedDates = {};

    final dateFormat = DateFormat('yyyy-MM-dd');

    for (var item in _fullForecast) {
      final dateStr = dateFormat.format(item.dateTime);

      if (!processedDates.contains(dateStr)) {
        processedDates.add(dateStr);
        _dailyForecast.add(item);
      }
    }
    if (_dailyForecast.length > 5) {
      _dailyForecast = _dailyForecast.sublist(0, 5);
    }
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _fullForecast = await _weatherService.getForecast(cityName: cityName);

      _processDailyForecast();

      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = "Không tìm thấy thành phố hoặc lỗi mạng.";
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();
    try {
      final position = await _locationService.getCurrentLocation();

      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      _fullForecast = await _weatherService.getForecast(
          lat: position.latitude,
          lon: position.longitude
      );

      _processDailyForecast();

      await _storageService.saveWeatherData(_currentWeather!);
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = "Không thể lấy vị trí hoặc lỗi mạng.";
      debugPrint(e.toString());
      await loadCachedWeather();
    }
    notifyListeners();
  }

  Future<void> loadCachedWeather() async {
    final cachedWeather = await _storageService.getCachedWeather();
    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _state = WeatherState.loaded;
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }


  // Section Code Block For Setting
  bool _isCelsius = true;
  bool get isCelsius => _isCelsius;

  void toggleUnit() {
    _isCelsius = !_isCelsius;
    notifyListeners();
  }

  double getTemperature(double tempInCelsius) {
    return _isCelsius ? tempInCelsius : (tempInCelsius * 9 / 5) + 32;
  }
  String get unitSymbol => _isCelsius ? "°C" : "°F";
}