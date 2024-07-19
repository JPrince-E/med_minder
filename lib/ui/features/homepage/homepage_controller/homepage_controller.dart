import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_minder/app/resources/app.logger.dart';
import 'package:med_minder/ui/shared/global_variables.dart';
import 'package:url_launcher/url_launcher.dart';

var log = getLogger('HomepageController');

class HomepageController extends GetxController {
  static HomepageController get to => Get.find();

  RxList<Map<String, dynamic>> drugSchedules = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    log.d('Fetching drug schedules...');
    fetchDrugSchedules();

    // Set up a real-time listener for changes in the database
    final ref = FirebaseDatabase.instance.ref('schedule/${GlobalVariables.myUsername}');
    ref.onValue.listen((event) {
      log.d('Database change detected');
      fetchDrugSchedules(); // Fetch drug schedules again when changes occur
    });
  }

  Future<void> fetchDrugSchedules() async {
    try {
      final ref = FirebaseDatabase.instance.ref('schedule/${GlobalVariables.myUsername}');
      final schedulesSnapshot = await ref.get();

      if (schedulesSnapshot.exists) {
        final List<Map<String, dynamic>> schedules = [];
        final dynamic snapshotValue = schedulesSnapshot.value;

        log.d('SchedulesSnapshot exist: $schedules');

        if (snapshotValue != null && snapshotValue is Map<dynamic, dynamic>) {
          snapshotValue.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              schedules.add(Map<String, dynamic>.from(value));
            }
          });

          drugSchedules.assignAll(schedules);
          log.d('Drug schedules fetched successfully: $schedules');

          // Schedule alarms for drugs that are due
          scheduleAlarmsForDueDrugs(schedules);
        } else {
          log.e('Invalid data format for schedules');
        }
      } else {
        log.e('No schedules found for user ${GlobalVariables.myUsername}');
      }
    } catch (e) {
      log.e('Error fetching drug schedules: $e');
    }
  }

  Future<void> makeEmergencyCall() async {
    try {
      final ref = FirebaseDatabase.instance.ref('users/${GlobalVariables.myUsername}');
      final userSnapshot = await ref.get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.value as Map<dynamic, dynamic>?;

        if (userData != null && userData.containsKey('emergencyContact')) {
          final String? emergencyNumber = userData['emergencyContact'] as String?;

          if (emergencyNumber != null && emergencyNumber.isNotEmpty) {
            final Uri launchUri = Uri(scheme: 'tel', path: emergencyNumber);
            if (await canLaunch(launchUri.toString())) {
              await launch(launchUri.toString());
              log.d('Launching $emergencyNumber');
              return;
            } else {
              log.e('Could not launch $emergencyNumber');
            }
          } else {
            log.e('Emergency contact number is null or empty');
          }
        } else {
          log.e('Emergency contact number not found in user data');
        }
      } else {
        log.e('User ${GlobalVariables.myUsername} does not exist');
      }
    } catch (e) {
      log.e('Error fetching emergency contact: $e');
    }
  }

  Future<void> scheduleAlarmsForDueDrugs(List<Map<String, dynamic>> schedules) async {
    final now = DateTime.now();

    for (var schedule in schedules) {
      final scheduleDetails = schedule.values.first;
      final List<String> scheduledTimes = (scheduleDetails['times'] as List<dynamic>).map((e) => e.toString()).toList();

      for (var time in scheduledTimes) {
        final timeComponents = time.split(' '); // Split by space for AM/PM and time
        if (timeComponents.length == 2) {
          final List<String> hmComponents = timeComponents[0].split(':');
          if (hmComponents.length == 2) {
            final int hours = int.parse(hmComponents[0]);
            final int minutes = int.parse(hmComponents[1]);
            final bool isPM = timeComponents[1].toLowerCase() == 'pm';
            final int adjustedHours = (isPM && hours < 12) ? hours + 12 : (hours == 12 ? 0 : hours);

            final DateTime scheduledTime = DateTime(now.year, now.month, now.day, adjustedHours, minutes);

            if (scheduledTime.isAfter(now)) {
              // Drug is due, schedule alarm
              await setAlarm(
                id: scheduleDetails['id'] ?? 0, // You may need to adjust this based on your data structure
                scheduleTime: TimeOfDay(hour: adjustedHours, minute: minutes),
                title: 'Medication Reminder',
                body: 'It\'s time to take ${scheduleDetails['medicationName']}',
              );
            }
          } else {
            log.e('Invalid time format in $time');
          }
        } else {
          log.e('Invalid time format in $time');
        }
      }
    }
  }

  Future<void> setAlarm({
    required int id,
    required TimeOfDay scheduleTime,
    required String title,
    required String body,
  }) async {
    final now = DateTime.now();
    DateTime alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      scheduleTime.hour,
      scheduleTime.minute,
    );

    // Check if time schedule is past already
    Duration difference = alarmTime.difference(DateTime.now());
    difference = difference + const Duration(minutes: 1);

    if (difference.isNegative == false) {
      // Define Alarm Parameters
      final alarmSettings = AlarmSettings(
        id: id,
        dateTime: alarmTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: false,
        vibrate: true,
        volume: 0.8,
        fadeDuration: 3.0,
        notificationTitle: title,
        notificationBody: body,
        enableNotificationOnKill: true,
        androidFullScreenIntent: true,
      );

      // Set the alarm
      await Alarm.set(alarmSettings: alarmSettings);
      log.d("Done setting alarm for $title at ${alarmTime.toIso8601String()}");
    }
  }
}
