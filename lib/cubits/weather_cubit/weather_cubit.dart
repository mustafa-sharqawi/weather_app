import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/weather_model.dart';
import '../../services/weather_service.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherService weatherService;
  String? cityName;
  WeatherModel? weatherModel;

  WeatherCubit(this.weatherService) : super(WeatherInitial());

  void getWeather({required String cityName}) async {
    emit(WeatherLoading());
    try {
      WeatherModel weatherModel =
          await weatherService.getWeather(cityName: cityName);
      emit(WeatherSuccess(weatherModel: weatherModel));
    } on Exception catch (e) {
      emit(WeatherFailure());
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
