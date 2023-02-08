import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation_tutorial_flutter/data/model/weather.dart';
import 'package:riverpod_annotation_tutorial_flutter/providers/weather_provider.dart';

class WeatherSearchPage extends ConsumerWidget {
  const WeatherSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<Weather?>>(
      asyncWeatherProvider,
      (_, state) {
        state.maybeMap(
            error: (error) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Couldn't fetch weather. Is the device online?"),
                  ),
                ),
            orElse: () => {});
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Weather Search')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Consumer(builder: (context, ref, child) {
          AsyncValue<Weather?> state = ref.watch(asyncWeatherProvider);

          return state.maybeWhen(
            data: (Weather? weather) {
              if (weather == null) {
                return buildInitialInput;
              }

              return buildColumnWithData(context, weather);
            },
            error: (error, _) {
              return buildInitialInput;
            },
            orElse: () {
              return const SizedBox.shrink();
            },
          );
        }),
      ),
    );
  }

  Widget get buildInitialInput => const Center(child: CityInputField());

  Widget get buildLoading => const Center(child: CircularProgressIndicator());

  Column buildColumnWithData(BuildContext context, Weather weather) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            weather.cityName,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            // Display the temperature with 1 decimal place
            '${weather.temperatureCelsius.toStringAsFixed(1)} °C',
            style: const TextStyle(fontSize: 80),
          ),
          ElevatedButton(
            // onPressed: () => Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => WeatherDetailPage(materWeather: weather),
            //   ),
            // ),
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.lightBlue[100]),
            ),
            child: const Text('See Details'),
          ),
          const CityInputField(),
        ],
      );
}

class CityInputField extends ConsumerWidget {
  const CityInputField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(ref, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(
            Icons.search,
          ),
        ),
      ),
    );
  }

  void submitCityName(WidgetRef ref, String cityName) =>
      ref.read(asyncWeatherProvider.notifier).getWeather(cityName);
}
