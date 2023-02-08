import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_annotation_tutorial_flutter/data/model/weather.dart';
import 'package:riverpod_annotation_tutorial_flutter/providers/weather_repository_provider.dart';

part 'weather_provider.g.dart';

@riverpod
class AsyncWeather extends _$AsyncWeather {
  @override
  FutureOr<Weather?> build() async {
    return null;
  }

  Future<void> getWeather(String cityName) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await ref.watch(weatherRepositoryProvider).fetchWeather(cityName);
    });
  }

  Future<void> getDetailWeather(String cityName) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await ref
          .watch(weatherRepositoryProvider)
          .fetchDetailWeather(cityName);
    });
  }
}
