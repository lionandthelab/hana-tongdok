//import 'package:auth_widget_builder/auth_widget_builder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hntd/firebase_options.dart';
import 'package:hntd/src/app.dart';
import 'package:hntd/src/localization/string_hardcoded.dart';
import 'package:hntd/src/features/onboarding/data/onboarding_repository.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("firebase initialized");

  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  final sharedPreferences = await SharedPreferences.getInstance();
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers();
  // * Entry point of the app

  final container = ProviderContainer(
    overrides: [
      onboardingRepositoryProvider.overrideWithValue(
        OnboardingRepository(sharedPreferences),
      ),
    ],
  );

  requestPermissions();
  print("requestPermissions");

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));

  _showNotification(); // 앱이 시작될 때 알림을 보여줍니다.
  _scheduleNotification(); // 앱이 시작될 때 알림을 예약합니다.
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestPermissions() async {
  // You can request multiple permissions at once.
  Map<Permission, PermissionStatus> statuses = await [
    Permission.notification,
    // Add other permissions you want to request here.
  ].request();

  // Check the permission status.
  if (!statuses[Permission.notification]!.isGranted) {
    // The permission is not granted, you can request again or show some kind of message.
    openAppSettings();
    print("openAppSettings");
  }
}

Future<void> _showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver',
          '하나통독 알림',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, '하나통독 알림', '말씀과 함께 하루를 시작해보세요!', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _scheduleNotification() async {
  var scheduledNotificationDateTime = Time(7, 0, 0);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver',
    '하나통독 알림',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      '하나통독 알림',
      '말씀과 함께 하루를 시작해보세요!',
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}
