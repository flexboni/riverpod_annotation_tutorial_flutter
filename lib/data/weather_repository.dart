import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation_tutorial_flutter/data/model/weather.dart';

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);

  Future<Weather> fetchDetailWeather(String cityName);
}

final fakeWeatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return FakeWeatherRepository();
});

class FakeWeatherRepository implements WeatherRepository {
  double? cachedTempCelsius = 0.0;

  @override
  Future<Weather> fetchWeather(String cityName) => Future.delayed(
        const Duration(seconds: 1),
        () => Weather(
          cityName: cityName,
          temperatureCelsius: cachedTempCelsius!,
          temperatureFahrenheit: cachedTempCelsius! * 1.8 + 32,
        ),
      );

  @override
  Future<Weather> fetchDetailWeather(String cityName) => Future.delayed(
        const Duration(seconds: 1),
        () {
          Random random = Random();

          // Simulate some network error
          if (random.nextBool()) {
            throw NetworkError();
          }

          // Since we're inside a fake repository, we need to cache the temperature
          // in order to have the same one returned in for the detailed weather
          cachedTempCelsius = 20 + random.nextInt(15) + random.nextDouble();

          return Weather(
            cityName: cityName,
            temperatureCelsius: cachedTempCelsius!,
          );
        },
      );
}

class NetworkError extends Error {}
