import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:med_minder/ui/features/schedule/schedule_controller/schedule_controller.dart';
import 'package:med_minder/ui/shared/custom_appbar.dart';
import 'package:med_minder/ui/shared/spacer.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final ScheduleController controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50),
          child: const CustomAppbar(
            title: "Schedule",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacer(10),
                _buildTextField('Medication Name', 'Enter Medication Name',
                    controller.medicationNameController),
                CustomSpacer(20),
                _buildDropdown(
                  'Amount',
                  controller.selectedAmount.value,
                  (newValue) {
                    if (newValue != null) {
                      controller.selectedAmount.value = newValue;
                    }
                  },
                  ['1 pill', '2 pills', '3 pills'],
                ),
                CustomSpacer(20),
                _buildDropdown(
                  'Dose',
                  controller.selectedDose.value,
                  (newValue) {
                    if (newValue != null) {
                      controller.selectedDose.value = newValue;
                    }
                  },
                  ['250 mg', '500 mg', '1000 mg'],
                ),
                CustomSpacer(20),
                _buildDropdown(
                  'Number of Times Per Day',
                  controller.noOfTimes.value.toString(),
                  (newValue) {
                    if (newValue != null) {
                      controller.noOfTimes.value = int.parse(newValue);
                      controller.selectedTime = List.generate(
                          controller.noOfTimes.value,
                          (_) => TimeOfDay.now().obs);
                      setState(() {});
                    }
                  },
                  List.generate(10, (index) => (index + 1).toString()),
                ),
                CustomSpacer(20),
                for (int i = 0; i < controller.noOfTimes.value; i++) ...[
                  CustomSpacer(20),
                  GestureDetector(
                    onTap: () => controller.showCustomTimePicker(context, i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(() => Text(
                            controller.selectedTime[i].value.format(context),
                            style: TextStyle(
                                fontSize: 16, color: AppColors.darkGray),
                          )),
                    ),
                  ),
                ],
                CustomSpacer(20),
                _buildDropdown(
                  'Number of Days',
                  controller.noOfDays.value.toString(),
                  (newValue) {
                    if (newValue != null) {
                      controller.noOfDays.value = int.parse(newValue);
                    }
                  },
                  List.generate(30, (index) => (index + 1).toString()),
                ),
                CustomSpacer(20),
                ElevatedButton(
                  onPressed: () => controller.addSchedule(context),
                  child: Center(
                    child: Text('Save Schedule'),
                  ),
                ),
                CustomSpacer(20),
                // Displaying fetched schedules
                Obx(() {
                  if (controller.schedules.isEmpty) {
                    return Center(child: Text("No schedules available."));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = controller.schedules[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  schedule.medicationName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CustomSpacer(10),
                                Text("Amount: ${schedule.selectedAmount}"),
                                CustomSpacer(10),
                                Text("Dose: ${schedule.selectedDose}"),
                                CustomSpacer(10),
                                Text("Number of Days: ${schedule.noOfDays}"),
                                CustomSpacer(10),
                                Text("Times:"),
                                ...schedule.times.map((time) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(time),
                                  );
                                }).toList(),
                                CustomSpacer(10),
                                Container(
                                  height: 10,
                                  width: double.infinity,
                                  color: controller.getColor(schedule.colour),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
                CustomSpacer(100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkGray,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSpacer(10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    ValueChanged<String?> onChanged,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkGray,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSpacer(10),
        DropdownButtonFormField<String>(
          value: value.isNotEmpty ? value : null,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}
