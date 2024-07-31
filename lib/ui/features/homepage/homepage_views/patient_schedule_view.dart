import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:med_minder/app/resources/app.logger.dart';
import 'package:med_minder/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';
import 'package:med_minder/utils/app_constants/app_styles.dart';

var log = getLogger('PatientScheduleView');

class PatientScheduleView extends StatelessWidget {
  final String username;
  final HomepageController controller = Get.find();

  PatientScheduleView({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$username\'s Schedule'),
        backgroundColor: AppColors.kPrimaryColor,
      ),
      body: Obx(() {
        final drugSchedules = controller.drugSchedules;
        log.d('Drug Schedules: $drugSchedules');

        // Filter the schedules for the specified username
        final patientSchedule = drugSchedules.where((schedule) => schedule['username'] == username).toList();

        if (patientSchedule.isEmpty) {
          return const Center(
            child: Text("No Records!"),
          );
        } else {
          final now = DateTime.now();
          final dueNow = <Map<String, dynamic>>[];
          final upcoming = <Map<String, dynamic>>[];

          log.d('Current Time: $now');

          for (var scheduleMap in patientSchedule) {
            final medicationName = scheduleMap['medicationName'] ?? 'No Name';
            final selectedAmount = scheduleMap['selectedAmount'] ?? 'Unknown';
            final selectedDose = scheduleMap['selectedDose'] ?? 'Unknown';
            final List<String> scheduledTimes = (scheduleMap['times'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

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

                    if (adjustedScheduledTime.isBefore(now)) {
                      dueNow.add({
                        'medicationName': medicationName,
                        'selectedAmount': selectedAmount,
                        'selectedDose': selectedDose,
                        'adjustedScheduledTime': adjustedScheduledTime,
                      });
                    } else {
                      upcoming.add({
                        'medicationName': medicationName,
                        'selectedAmount': selectedAmount,
                        'selectedDose': selectedDose,
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
                    _buildMedicationList(dueNow),
                  ],
                  if (upcoming.isNotEmpty) ...[
                    const Text(
                      "Upcoming:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _buildMedicationList(upcoming),
                  ],
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildMedicationList(List<Map<String, dynamic>> medications) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: medications.length,
      itemBuilder: (context, index) {
        final medication = medications[index];
        final medicationName = medication['medicationName'] ?? 'No Name';
        final selectedAmount = medication['selectedAmount'] ?? 'Unknown';
        final selectedDose = medication['selectedDose'] ?? 'Unknown';
        final adjustedScheduledTime = medication['adjustedScheduledTime'] as DateTime?;

        return Card(
          child: ListTile(
            title: Text(medicationName),
            subtitle: Text('Amount: $selectedAmount - Dose: $selectedDose'),
            trailing: adjustedScheduledTime != null
                ? Text('Time: ${DateFormat.jm().format(adjustedScheduledTime)}')
                : const Text('Time: Not specified'),
          ),
        );
      },
    );
  }
}
