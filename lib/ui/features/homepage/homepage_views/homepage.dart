import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:med_minder/app/resources/app.logger.dart';
import 'package:med_minder/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:med_minder/ui/features/homepage/homepage_views/patient_schedule_view.dart';
import 'package:med_minder/ui/shared/global_variables.dart';
import 'package:med_minder/ui/shared/spacer.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';
import 'package:med_minder/utils/app_constants/app_styles.dart';
import 'package:med_minder/utils/screen_util/screen_util.dart';
import 'package:one_clock/one_clock.dart';
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

        if (GlobalVariables.myRole == 'doctor') {
          // Render the doctor view showing patients
          if (drugSchedules.isEmpty) {
            log.e('Patients: $drugSchedules');
            return const Center(
              child: Text("No Patients!"),
            );
          } else {
            return ListView.builder(
              itemCount: drugSchedules.length,
              itemBuilder: (context, index) {
                final patient = drugSchedules[index];
                final username = patient['username'] ?? 'Unknown';
                return ListTile(
                  title: Text(username),
                  subtitle: Text('View Schedule'),
                  onTap: () {
                    // Navigate to patient's schedule
                    Get.to(PatientScheduleView(username: username));
                  },
                );
              },
            );
          }
        } else if (GlobalVariables.myRole == 'patient') {
          // Render the patient view showing their schedule
          if (drugSchedules.isEmpty) {
            log.e('Drug Schedules: $drugSchedules');
            return const Center(
              child: Text("No Records!"),
            );
          } else {
            final now = DateTime.now();
            final dueNow = <Map<String, dynamic>>[];
            final upcoming = <Map<String, dynamic>>[];

            log.d('Current Time: $now');

            for (var scheduleMap in drugSchedules) {
              scheduleMap.forEach((key, scheduleDetails) {
                // Ensure the schedule belongs to the logged-in patient
                if (scheduleDetails['username'] == GlobalVariables.myUsername) {
                  final medicationName =
                      scheduleDetails['medicationName'] ?? 'No Name';
                  final selectedAmount =
                      scheduleDetails['selectedAmount'] ?? 'Unknown';
                  final selectedDose =
                      scheduleDetails['selectedDose'] ?? 'Unknown';
                  final List<String> scheduledTimes =
                      (scheduleDetails['times'] as List<dynamic>?)
                              ?.map((e) => e.toString())
                              .toList() ??
                          [];

                  for (var time in scheduledTimes) {
                    final List<String> timeComponents = time.split(' ');
                    if (timeComponents.length == 2) {
                      final List<String> hmComponents =
                          timeComponents[0].split(':');
                      if (hmComponents.length == 2) {
                        try {
                          final int hours = int.parse(hmComponents[0]);
                          final int minutes = int.parse(hmComponents[1]);
                          final bool isPM =
                              timeComponents[1].toLowerCase() == 'pm';
                          final int adjustedHours = (isPM && hours < 12)
                              ? hours + 12
                              : (hours == 12 ? 0 : hours);

                          final DateTime scheduledTime = DateTime(now.year,
                              now.month, now.day, adjustedHours, minutes);
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
        } else {
          return const Center(
            child: Text("User role not recognized!"),
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
              "Hi " + GlobalVariables.myUsername,
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
                          DateFormat.yMMMMEEEEd()
                              .format(DateTime.now())
                              .toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.plainWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // DigitalClock(
                        //   is24HourTimeFormat: false,
                        //   hourMinuteDigitTextStyle: const TextStyle(
                        //     fontSize: 35,
                        //     color: Colors.amber,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        //   showSecondsDigit: false,
                        //   amPmDigitTextStyle: TextStyle(
                        //     fontSize: 15,
                        //     color: AppColors.plainWhite,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        const DigitalClock(
                          format: 'jm',
                          isLive: true,
                          showSeconds: false,
                          digitalClockTextColor: Colors.amber,
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

  Widget _buildMedicationList(
      List<Map<String, dynamic>> medications, bool isDueNow) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: medications.length,
      itemBuilder: (context, index) {
        final medication = medications[index];
        final medicationName = medication['medicationName'] ?? 'No Name';
        final selectedAmount = medication['selectedAmount'] ?? 'Unknown';
        final selectedDose = medication['selectedDose'] ?? 'Unknown';
        final adjustedScheduledTime =
            medication['adjustedScheduledTime'] as DateTime?;

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
