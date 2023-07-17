import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/weather_cubit/weather_cubit.dart';
import '../cubits/weather_cubit/weather_state.dart';
import '../models/weather_model.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? weatherData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SearchPage();
              }));
            },
            icon: const Icon(Icons.search),
          ),
        ],
        centerTitle: true,
        title: const Text('Weather App'),
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherSuccess) {
            return SuccessBody(weatherData: state.weatherModel);
          } else if (state is WeatherFailure) {
            return const Center(
              child: Text('Something Went Wrong Please Try Again...'),
            );
          } else {
            return const DefaultBody();
          }
        },
      ),
    );
  }
}

class DefaultBody extends StatefulWidget {
  const DefaultBody({
    super.key,
  });

  @override
  State<DefaultBody> createState() => _DefaultBodyState();
}

class _DefaultBodyState extends State<DefaultBody> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'there is no weather 😔 start',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Text(
            'searching now 🔍',
            style: TextStyle(
              fontSize: 30,
            ),
          )
        ],
      ),
    );
  }
}

class SuccessBody extends StatefulWidget {
  const SuccessBody({
    super.key,
    required this.weatherData,
  });

  final WeatherModel? weatherData;

  @override
  State<SuccessBody> createState() => _SuccessBodyState();
}

class _SuccessBodyState extends State<SuccessBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          widget.weatherData!.getThemeColor(),
          widget.weatherData!.getThemeColor()[300]!,
          widget.weatherData!.getThemeColor()[100]!,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(
            flex: 3,
          ),
          Text(
            BlocProvider.of<WeatherCubit>(context).cityName!,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'updated at : ${widget.weatherData!.date.hour}:${widget.weatherData!.date.minute}',
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(widget.weatherData!.getImage()),
              Text(
                widget.weatherData!.temp.toInt().toString(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  Text('maxTemp :${widget.weatherData!.maxTemp.toInt()}'),
                  Text('minTemp : ${widget.weatherData!.minTemp.toInt()}'),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            widget.weatherData!.weatherStateName,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(
            flex: 5,
          ),
        ],
      ),
    );
  }
}
