import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_minder/ui/shared/global_variables.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyController extends GetxController {
  TextEditingController emergencyNumberController = TextEditingController();

  void saveEmergencyContact(BuildContext context) async {
    String emergencyNumber = emergencyNumberController.text.trim();

    if (_isValidPhoneNumber(emergencyNumber)) {
      try {
        // Check if the user already has an entry in the database
        final ref = FirebaseDatabase.instance.ref();
        final userSnapshot = await ref.child('users/${GlobalVariables.myUsername}').get();

        if (userSnapshot.exists) {
          // If the user exists, update their emergency contact number
          await ref.child('users/${GlobalVariables.myUsername}').update({
            'emergencyContact': emergencyNumber,
          });

          print('Emergency contact number updated for ${GlobalVariables.myUsername}');
        } else {
          // If the user does not exist, show an error message
          print('Error: User ${GlobalVariables.myUsername} not found');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User not found')),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Emergency contact number saved/updated')),
        );
      } catch (e) {
        print('Error saving/updating emergency contact: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving/updating emergency contact')),
        );
      }
    } else {
      print('Invalid phone number');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid phone number')),
      );
    }
  }

  bool _isValidPhoneNumber(String number) {
    return number.isNotEmpty; // Basic validation: check if not empty
  }

  void makeEmergencyCall() async {
    String emergencyNumber = emergencyNumberController.text.trim();
    if (emergencyNumber.isNotEmpty) {
      try {
        await launch('tel:$emergencyNumber');
        print('Could launch $emergencyNumber');
      } catch (e) {
        print('Error launching $emergencyNumber: $e');
      }
    } else {
      print('Phone number is null or empty');
    }
  }
}
