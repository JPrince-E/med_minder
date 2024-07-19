import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:med_minder/app/resources/app.logger.dart';
import 'package:med_minder/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:med_minder/ui/shared/spacer.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';
import 'package:med_minder/utils/app_constants/app_styles.dart';
import 'package:med_minder/utils/screen_util/screen_util.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:timer_builder/timer_builder.dart';

var log = getLogger('HomepageView');

class HomepageView extends StatelessWidget {
  final HomepageController controller = Get.find();

  HomepageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize(context).width, 180),
        child: Container(
          height: 430,
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            children: [
              _buildUserInfo(),
              _buildDigitalClock(),
            ],
          ),
        ),
      ),
      body: Obx(() {
      final drugSchedules = controller.drugSchedules;

      if (drugSchedules.isEmpty) {
        log.e('Drug Schedules: $drugSchedules');
        return const Center(
          child: Text("No Records!"),
        );
      } else {
        log.d('Drug Schedules: $drugSchedules');
        final now = DateTime.now();
        final dueNow = <Map<String, dynamic>>[];
        final upcoming = <Map<String, dynamic>>[];

        log.d('Current Time: $now');

        for (var scheduleMap in drugSchedules) {
          scheduleMap.forEach((key, scheduleDetails) {
            log.d('Processing schedule: $scheduleDetails');
            final List<String> scheduledTimes = (scheduleDetails['times'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

            for (var time in scheduledTimes) {
              final List<String> timeComponents = time.split(' ');
              if (timeComponents.length == 2) {
                final List<String> hmComponents = timeComponents[0].split(':');
                if (hmComponents.length == 2) {
                  try {
                    final int hours = int.parse(hmComponents[0]);
                    final int minutes = int.parse(hmComponents[1]);
                    final bool isPM = timeComponents[1].toLowerCase() == 'pm';
                    final int adjustedHours = (isPM && hours < 12) ? hours + 12 : (hours == 12 ? 0 : hours);

                    final DateTime scheduledTime = DateTime(now.year, now.month, now.day, adjustedHours, minutes);
                    final adjustedScheduledTime = scheduledTime;

                    log.d('Scheduled time: $adjustedScheduledTime');

                    if (adjustedScheduledTime.isBefore(now)) {
                      log.d('Adding medication to dueNow: $scheduleDetails');
                      dueNow.add({
                        ...scheduleDetails,
                        'adjustedScheduledTime': adjustedScheduledTime,
                      });
                    } else {
                      log.d('Adding medication to upcoming: $scheduleDetails');
                      upcoming.add({
                        ...scheduleDetails,
                        'adjustedScheduledTime': adjustedScheduledTime,
                      });
                    }
                  } catch (e) {
                    log.e('Error parsing time: $time, $e');
                  }
                } else {
                  log.e('Invalid time format: $time');
                }
              } else {
                log.e('Invalid time format: $time');
              }
            }
          });
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dueNow.isNotEmpty) ...[
                  const Text(
                    "Due Now:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildMedicationList(dueNow, true),
                ],
                if (upcoming.isNotEmpty) ...[
                  const Text(
                    "Upcoming:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildMedicationList(upcoming, false),
                ],
              ],
            ),
          ),
        );
      }
    }),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.blueGray,
              backgroundImage: const AssetImage("assets/images/passport.png"),
              radius: 30,
            ),
            CustomRowSpacer(10),
            Text(
              "Hi Prince E",
              style: AppStyles.regularStringStyle(18, AppColors.plainWhite),
            ),
          ],
        ),
        Column(
          children: [
            IconButton(
              onPressed: controller.makeEmergencyCall,
              icon: Icon(
                Icons.contact_phone,
                color: AppColors.coolRed,
                size: 40,
              ),
            ),
            Text(
              'Emergency',
              style: TextStyle(color: AppColors.plainWhite, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDigitalClock() {
    return TimerBuilder.periodic(
      const Duration(minutes: 1),
      builder: (context) {
        print(' >>>>> Checking time . . .');
        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.yMMMMEEEEd().format(DateTime.now()).toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.plainWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        DigitalClock(
                          is24HourTimeFormat: false,
                          hourMinuteDigitTextStyle: const TextStyle(
                            fontSize: 35,
                            color: Colors.amber,
                            fontWeight: FontWeight.w700,
                          ),
                          showSecondsDigit: false,
                          amPmDigitTextStyle: TextStyle(
                            fontSize: 15,
                            color: AppColors.plainWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMedicationList(List<Map<String, dynamic>> schedules, bool isDueNow) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: schedules.map((schedule) {
      final medicationName = schedule['medicationName'] ?? 'No Name';
      final selectedAmount = schedule['selectedAmount'] ?? '';
      final selectedDose = schedule['selectedDose'] ?? '';
      final adjustedScheduledTime = schedule['adjustedScheduledTime'] as DateTime?;

      log.d('Medication Name: $medicationName');
      log.d('Selected Amount: $selectedAmount');
      log.d('Selected Dose: $selectedDose');
      log.d('Adjusted Scheduled Time: $adjustedScheduledTime');

      return Card(
          color: isDueNow ? Colors.redAccent : Colors.yellowAccent,
        child: ListTile(
          title: Text(medicationName),
          subtitle: Text('Amount: $selectedAmount - Dose: $selectedDose'),
          trailing: adjustedScheduledTime != null
              ? Text('Time: ${DateFormat.jm().format(adjustedScheduledTime)}')
              : const Text('Time: Not specified'),
        ),
      );
        }).toList(),
    );
  }
}

