import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_minder/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:med_minder/ui/features/schedule/schedule_controller/schedule_controller.dart';

final ScheduleController controller = Get.put(ScheduleController());
final HomepageController _controller = HomepageController.to;

Widget _buildRoundedTextField(
    String label, TextEditingController controller, IconData icon) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
      ),
    ),
  );
}

Widget _buildDropdown(String label, String value, List<String> items,
    Function(String?) onChanged) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
        ),
      ),
    ),
  );
}

String _getDoseSuffix(int doseNumber) {
  if (doseNumber % 10 == 1 && doseNumber % 100 != 11) {
    return 'st';
  } else if (doseNumber % 10 == 2 && doseNumber % 100 != 12) {
    return 'nd';
  } else if (doseNumber % 10 == 3 && doseNumber % 100 != 13) {
    return 'rd';
  } else {
    return 'th';
  }
}

Widget _buildTimeFields(int noOfTimes, BuildContext context) {
  List<Widget> timeFields = [];
  controller.selectedTime.add(TimeOfDay.now().obs);
  for (int i = 0; i < noOfTimes; i++) {
    timeFields.add(
      Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 8.0),
              Text(
                'Time of ${i + 1}${_getDoseSuffix(i + 1)} dose:     ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      controller.showCustomTimePicker(context, i);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.notifications,
                              color: Colors.blue,
                            ),
                          ),
                          Obx(() {
                            return Text(
                              controller.selectedTime[i].value.format(context),
                              textAlign: TextAlign.center,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
  return Column(
    children: timeFields,
  );
}

void _showColorPicker(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Pick a Color'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildColorDropdown(), // Use the color dropdown
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildColorDropdown() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: controller.selectedColor.value,
        onChanged: (String? value) {
          if (value != null) {
            controller.selectedColor.value = value;
          }
        },
        items: controller.colours
            .map<DropdownMenuItem<String>>(
              (Rx<String> color) => DropdownMenuItem<String>(
                value: color.value,
                child: Container(
                  width: 30,
                  height: 30,
                  color: controller.getColor(color.value),
                ),
              ),
            )
            .toList(),
        decoration: const InputDecoration(
          hintText: 'Color',
          border: InputBorder.none,
        ),
      ),
    ),
  );
}
