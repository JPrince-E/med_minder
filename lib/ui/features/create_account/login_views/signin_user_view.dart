import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:med_minder/ui/features/create_account/login_controller/login_controller.dart';
import 'package:med_minder/ui/shared/custom_button.dart';
import 'package:med_minder/ui/shared/custom_textfield_.dart';
import 'package:med_minder/ui/shared/spacer.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';
import 'package:med_minder/utils/app_constants/app_styles.dart';
import 'package:med_minder/utils/screen_util/screen_util.dart';

class SignInView extends StatelessWidget {
  SignInView({Key? key}) : super(key: key);

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        body: Container(
          height: size.height,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/doc_bg.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextfield(
                    textEditingController: controller.usernameController,
                    labelText: 'Username',
                    hintText: 'Enter your preferred username',
                  ),
                  CustomSpacer(20),
                  CustomTextfield(
                    textEditingController: controller.passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your preferred password',
                  ),
                  CustomSpacer(20),
                  Obx(
                        () => Center(
                      child: Text(
                        controller.errMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  CustomSpacer(10),
                  Center(
                    child: Obx(
                          () => controller.showLoading.value
                          ? const CircularProgressIndicator()
                          : CustomButton(
                        styleBoolValue: true,
                        height: 55,
                        width: screenSize(context).width * 0.6,
                        color: Colors.blue[800],
                        child: Text(
                          controller.isSignUp.value ? 'Sign Up' : 'Log In',
                          style: AppStyles.regularStringStyle(
                            18,
                            AppColors.plainWhite,
                          ),
                        ),
                        onPressed: () {
                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                          if (controller.isSignUp.value) {
                            controller.signUpUser(context);
                          } else {
                            controller.attemptToSignInUser(context);
                          }
                        },
                      ),
                    ),
                  ),
                  CustomSpacer(20),
                  TextButton(
                    onPressed: controller.toggleSignUpSignIn,
                    child: Obx(
                          () => Text(
                        controller.isSignUp.value
                            ? 'Already have an account? Sign in'
                            : 'Don\'t have an account? Sign up',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
