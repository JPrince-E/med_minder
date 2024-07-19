import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med_minder/app/resources/app.logger.dart';

var log = getLogger('PushNotificationService');

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String deviceToken = '';

  Future initialize() async {
    if (Platform.isIOS) {
      //Requires IOS permission
      await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }

    //This is used to get the current device token
    await _fcm.getToken().then((token) {
      deviceToken = token!;
      log.wtf("deviceToken: $deviceToken");
    });

    // Enable Background Notification to retrieve any message that caused the application to open from a terminated state
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();

    // This function routes to home view if the data property received has a type of home
    Future<void> handleMessage(RemoteMessage message) async {
      log.wtf(
          "name: ${message.data["name"]}, channelId: ${message.data["channelId"]}");
    }

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    // This handles any interaction when the app is open but in the background and not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    //Enable foreground Notification for iOS
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // To handle messages while your application is in foreground for android we listen to the onMessage stream.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showNotification(message);
    });

    // This is used to define the initialization settings for iOS and android
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // This handles routing to a secific page when there's a click event on the notification
    void onSelectNotification(NotificationResponse notificationResponse) async {
      debugPrint(notificationResponse.payload);
      var payloadData = jsonDecode(notificationResponse.payload!);

      // NavigationService.navigatorKey.currentContext?.go('/homepageView');
      log.wtf(">>>>>> ${payloadData["title"]}");
    }

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);
  }

  Future showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'fcm_default_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Display the foreground notification
    if (message.notification != null) {
      RemoteNotification? notification = message.notification;

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: Importance.max,
        playSound: true,
        channelDescription: channel.description,
        priority: Priority.high,
        ongoing: true,
        color: Colors.blue.shade900,
        styleInformation: const BigTextStyleInformation(''),
      );

      var iOSChannelSpecifics = const DarwinNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        platformChannelSpecifics,
        payload: jsonEncode(message.data),
      );
    }
  }
}
