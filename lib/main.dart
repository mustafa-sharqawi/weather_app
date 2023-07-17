import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification/services/weather_service.dart';
import 'cubits/weather_cubit/weather_cubit.dart';
import 'pages/home_page.dart';

Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  runApp(
      BlocProvider(
      create: (context) {
        return WeatherCubit(WeatherService());
      },
      child: const WeatherApp()));
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});
  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  @override
  void initState(){
    super.initState();
    getToken();
    initMessaging();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:
            BlocProvider.of<WeatherCubit>(context).weatherModel == null
                ? Colors.blue
                : BlocProvider.of<WeatherCubit>(context)
                    .weatherModel!
                    .getThemeColor(),
      ),
      home: const HomePage(),
    );
  }
  void getToken(){
    _messaging.getToken().then((value){
      String? token =value;
      if (kDebugMode) {
        print('Token : $token');
      }
    });
  }
  void initMessaging() {
    var androidInit =
    const AndroidInitializationSettings('@mipmap/ic_launcher'); //for Logo
    var initSetting = InitializationSettings (android: androidInit);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initSetting);
    var androidDetails = const AndroidNotificationDetails('1', 'Default',
        channelDescription: "Channel Description",
        importance: Importance.high,
        priority: Priority.high);
    var generalNotificationDetails =
    NotificationDetails (android: androidDetails);
    FirebaseMessaging.onMessage.listen ((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      flutterLocalNotificationsPlugin.show(notification.hashCode,
          notification.title, notification.body, generalNotificationDetails);
    });
  }
}
