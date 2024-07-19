import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_minder/app/helpers/sharedprefs.dart';
import 'package:med_minder/app/resources/app.logger.dart';
import 'package:med_minder/ui/features/create_account/create_account_model/user_model.dart';
import 'package:med_minder/ui/shared/global_variables.dart';

final log = getLogger('CreateUserController');

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var isSignUp = false.obs;
  var errMessage = ''.obs;
  var showLoading = false.obs;
  var imageFile = Rx<File?>(null);

  void toggleSignUpSignIn() {
    isSignUp.value = !isSignUp.value;
  }

  void resetValues() {
    errMessage.value = '';
    showLoading.value = false;
  }

  void gotoSignInUserPage(BuildContext context) {
    log.d('Going to sign in user page');
    resetValues();
    context.push('/signInView');
  }

  void gotoHomepage(BuildContext context) {
    log.d('Going to home screen');
    resetValues();
    context.go('/homeScreen');
  }

  void attemptToSignInUser(BuildContext context) {
    log.d('Attempting to sign in user...');
    errMessage.value = '';

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isNotEmpty && !username.contains(' ')
        && password.isNotEmpty && !password.contains(' ')) {
      log.d('Signing in user...');
      showLoading.value = true;
      errMessage.value = '';
      signInUser(context);
    } else {
      errMessage.value = 'All fields must be filled, and with no spaces';
      log.d("Error message: $errMessage");
      showLoading.value = false;
    }
  }

  Future<void> signInUser(BuildContext context) async {
    log.d('Checking if user exists...');
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/${usernameController.text.trim()}').get();

    if (snapshot.exists) {
      log.d("User exists: ${snapshot.value}");
      final userData = UserModel.fromJson(jsonDecode(jsonEncode(snapshot.value)));

      if (userData.password == passwordController.text.trim()) {
        showLoading.value = false;
        GlobalVariables.myUsername = usernameController.text.trim();
        GlobalVariables.myFullName = userData.fullName ?? '';
        log.d("GlobalVariables Username: ${GlobalVariables.myUsername}");
        await saveSharedPrefsStringValue("myUsername", usernameController.text.trim());
        gotoHomepage(context);
      } else {
        log.d('Password does not match.');
        errMessage.value = "Error! Username or password incorrect";
        showLoading.value = false;
      }
    } else {
      log.d('User data does not exist.');
      errMessage.value = "Error! User ${usernameController.text.trim()} not found";
      showLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> signUpUser(BuildContext context) async {
    log.d('Attempting to sign up user...');

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      errMessage.value = 'All fields must be filled out.';
      log.d('Error: $errMessage');
      return;
    }

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/$username').get();

    if (snapshot.exists) {
      errMessage.value = 'User $username already exists.';
      log.d('Error: ${errMessage.value}');
      return;
    }

    final newUser = UserModel(
      username: username,
      password: password,
    );

    await ref.child('users/$username').set(newUser.toJson());
    log.d('User $username successfully signed up.');

    attemptToSignInUser(context);
  }
}
