import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_annotation_tutorial_flutter/data/weather_repository.dart';

part 'weather_repository_provider.g.dart';

@riverpod
WeatherRepository weatherRepository(WeatherRepositoryRef ref) {
  debugPrint("weatherRepository");
  return FakeWeatherRepository();
}
