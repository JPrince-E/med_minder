import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Medication {
  final String medicationName;
  final String selectedAmount;
  final String selectedDose;
  final int noOfTimes;
  final int noOfDays;
  final List<String> times;
  final String colour;

  Medication({
    required this.medicationName,
    required this.selectedAmount,
    required this.selectedDose,
    required this.noOfTimes,
    required this.noOfDays,
    required this.times,
    required this.colour,
  });

  factory Medication.fromRealtimeDatabaseSnapshot(Map<dynamic, dynamic> data) {
    return Medication(
      medicationName: data['medicationName'],
      selectedAmount: data['selectedAmount'],
      selectedDose: data['selectedDose'],
      noOfTimes: int.parse(data['noOfTimes'].toString()),
      noOfDays: int.parse(data['noOfDays'].toString()),
      times: List<String>.from(data['times']),
      colour: data['colour'],
    );
  }

  static Stream<List<Medication>> medicationsStream() {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('schedule');

    return databaseReference.onValue.map((event) {
      List<Medication> medications = [];
      Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        data.forEach((key, value) {
          medications.add(Medication.fromRealtimeDatabaseSnapshot(value));
        });
      }

      return medications;
    });
  }
}
