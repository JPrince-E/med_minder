import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:med_minder/app/resources/app.locator.dart';
import 'package:med_minder/firebase_options.dart';
import 'package:med_minder/med_minder.dart';
import 'package:med_minder/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(const MyApp());
// }

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await setupLocator();

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  final prefs = await SharedPreferences.getInstance();
  final savedUsername = prefs.getString('myUsername');
  final savedPassword = prefs.getString('myPassword');

  Get.put(HomepageController());

  runApp(MedMinder(
    savedUsername: savedUsername,
    savedPassword: savedPassword,
  ));
}
