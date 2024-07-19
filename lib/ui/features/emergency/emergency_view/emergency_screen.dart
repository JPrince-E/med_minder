import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_minder/ui/features/emergency/emergency_controller/emrgency_controller.dart';
import 'package:med_minder/ui/shared/custom_button.dart';
import 'package:med_minder/ui/shared/spacer.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final controller = Get.put(EmergencyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency Settings',
          style: TextStyle(color: AppColors.deepBlue),
        ),
        backgroundColor: AppColors.kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Set Emergency Contact Number:',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.deepBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomSpacer(20),
                  TextField(
                    controller: controller.emergencyNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Emergency Contact Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  CustomSpacer(20),
                  CustomButton(
                    onPressed: () {
                      controller.saveEmergencyContact(context);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: AppColors.kPrimaryColor,
                    width: 100,
                  ),
                  CustomSpacer(20),
                  CustomButton(
                    onPressed: () {
                      controller.makeEmergencyCall();
                    },
                    child: Text(
                      'Call Emergency',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: AppColors.kPrimaryColor,
                    width: 200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
