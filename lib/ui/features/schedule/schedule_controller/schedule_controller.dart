import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:med_minder/ui/features/schedule/schedule_model/medication_model.dart';
import 'package:med_minder/ui/shared/global_variables.dart';

class ScheduleController extends GetxController {
  static ScheduleController get to => Get.find();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  final TextEditingController medicationNameController = TextEditingController();
  final TextEditingController patientUsernameController = TextEditingController();
  RxString selectedAmount = '1 pill'.obs;
  RxString selectedDose = '250 mg'.obs;
  RxInt noOfTimes = 1.obs;
  RxInt noOfDays = 1.obs;
  List<Rx<TimeOfDay>> selectedTime = [];
  RxString selectedColor = "#808080".obs;
  RxList<Medication> schedules = RxList<Medication>();

  final List<RxString> colours = [
    "#808080".obs,
    "#FF0000".obs,
    "#0000FF".obs,
    "#FFFF00".obs,
    "#00FFFF".obs,
    "#FF00FF".obs,
  ];

  Color getColor(String colorHex) =>
      Color(int.parse(colorHex.substring(1, colorHex.length), radix: 16) + 0xFF000000);

  bool showProgressBar = false;

  @override
  void onInit() {
    super.onInit();
    selectedTime = List.generate(noOfTimes.value, (_) => TimeOfDay.now().obs);
    fetchSchedules();
  }

  @override
  void onClose() {
    medicationNameController.dispose();
    patientUsernameController.dispose();
    super.onClose();
  }

  void incrementNoOfTimes() {
    noOfTimes.value++;
    selectedTime.add(TimeOfDay.now().obs);
  }

  void decrementNoOfTimes() {
    if (noOfTimes.value > 1) {
      noOfTimes.value--;
      selectedTime.removeLast();
    }
  }

  void incrementNoOfDays() {
    noOfDays.value++;
  }

  void decrementNoOfDays() {
    if (noOfDays.value > 1) {
      noOfDays.value--;
    }
  }

  Future<void> showCustomTimePicker(BuildContext context, int fieldIndex) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime[fieldIndex].value,
    );
    if (pickedTime != null) {
      selectedTime[fieldIndex].value = pickedTime;
      update();
    }
  }

  Future<void> addSchedule(BuildContext context) async {
    try {
      List<String> timeStrings = selectedTime.map((time) => time.value.format(context)).toList();

      String username = GlobalVariables.myUsername;
      if (GlobalVariables.myRole == 'doctor') {
        username = patientUsernameController.text.trim();
      }

      await _database.child('schedule/$username').push().set({
        "medicationName": medicationNameController.text.trim(),
        "selectedAmount": selectedAmount.value,
        "selectedDose": selectedDose.value,
        "noOfTimes": noOfTimes.value,
        "noOfDays": noOfDays.value,
        "times": timeStrings,
        "colour": selectedColor.value,
      }).then((_) {
        Get.snackbar("Successful", "Schedule uploaded successfully.");
      });

      resetFields();
    } catch (e) {
      print("Exception occurred: ${e.toString()}");
      Get.snackbar("Error", "Failed to upload schedule. Please try again.");
    }
  }

  void resetFields() {
    medicationNameController.clear();
    patientUsernameController.clear();
    selectedAmount.value = '1 pill';
    selectedDose.value = '250 mg';
    noOfTimes.value = 1;
    noOfDays.value = 1;
    selectedTime = List.generate(noOfTimes.value, (_) => TimeOfDay.now().obs);
    selectedColor.value = "#808080";
  }

  void fetchSchedules() {
    String username = GlobalVariables.myUsername;

    _database.child('schedule/$username').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        schedules.value = data.entries.map((entry) {
          return Medication.fromRealtimeDatabaseSnapshot(entry.value);
        }).toList();
      } else {
        schedules.clear();
      }
    });
  }
}
