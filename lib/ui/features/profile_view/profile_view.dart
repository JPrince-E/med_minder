import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:med_minder/ui/features/create_account/login_views/signin_user_view.dart';
import 'package:med_minder/ui/shared/spacer.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          Container(
            height: 400,
            padding: const EdgeInsets.only(
              top: 50,
              left: 50,
              right: 50,
            ),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Prince E',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.plainWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CustomSpacer(10),
                    CircleAvatar(
                      backgroundColor: AppColors.blueGray,
                      backgroundImage:
                          const AssetImage("assets/images/passport.png"),
                      radius: 80,
                    ),
                    CustomSpacer(20),
                    Text(
                      'adebayoea1@gmail.com',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomSpacer(10),
                    Text(
                      '08169020314',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.deepBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomSpacer(10),
                    Text(
                      'Male',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.deepBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  wrapperContainer(
                    child: ListTile(
                      leading: const Icon(
                        Icons.contact_emergency_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      title: const Text(
                        "Set Up Emergency",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onTap: () {
                        context.push('/emergencyScreen');
                      },
                    ),
                  ),
                  wrapperContainer(
                    color: Colors.red,
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        size: 30,
                        color: Colors.white,
                      ),
                      title: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onTap: () {
                        context.pushReplacement('/signInView');
                      },
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

Widget wrapperContainer({required Widget child, Color? color}) {
  return Container(
    decoration: BoxDecoration(
      color: color ?? Colors.blue, // Blue background color
      border: Border.all(color: Colors.orange, width: 2), // Orange border
      borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.all(5),
    child: child,
  );
}
