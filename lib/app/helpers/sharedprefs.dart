// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSharedPrefsStringValue(String stringKey, String stringValue) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(stringKey, stringValue);
  print('Saved $stringKey as $stringValue');
}

Future<String> getSharedPrefsSavedString(String stringKey) async {
  final prefs = await SharedPreferences.getInstance();
  final String? readValue = prefs.getString(stringKey);
  print('Retrieved value for $stringKey is $readValue.');
  return readValue ?? '';
}
