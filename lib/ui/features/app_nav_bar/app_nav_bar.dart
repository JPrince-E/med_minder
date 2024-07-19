import 'package:flutter/material.dart';

import 'package:med_minder/ui/features/homepage/homepage_views/homepage.dart';
import 'package:med_minder/ui/features/profile_view/profile_view.dart';
import 'package:med_minder/ui/features/schedule/schedule_view/schedule_view.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';

class AppNavBar extends StatefulWidget {
  final String? userID;

  const AppNavBar({
    Key? key,
    this.userID,
  }) : super(key: key);

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  int screenIndex = 0;
  String senderName = "";
  List tabScreenList = [
    HomepageView(),
    const ScheduleView(),
    // const NotificationScreen(),
    const ProfilePageView(),
  ];

  String fullName = '';
  String email = '';
  String imageProfile =
      'https://firebasestorage.googleapis.com/v0/b/dating-app-a5c06.appspot.com/o/Place%20Holder%2Fprofile_avatar.jpg?alt=media&token=dea921b1-1228-47c2-bc7b-01fb05bd8e2d';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.plainWhite,
      body: Stack(
        children: [
          Positioned.fill(
            child: tabScreenList[screenIndex],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              height: kBottomNavigationBarHeight + 20,
              width: 10,
              decoration: BoxDecoration(
                color: AppColors
                    .anotherLightGray, // Set color of the navigation bar background
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavBarItem(Icons.home, "Home", 0),
                  _buildNavBarItem(Icons.add, "Create", 1),
                  // _buildNavBarItem(Icons.notifications, "", 2),
                  _buildNavBarItem(Icons.person, "Profile", 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData iconData, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          screenIndex = index;
        });
      },
      child: Container(
        height: 55,
        width: kBottomNavigationBarHeight + 50,
        decoration: BoxDecoration(
          color: screenIndex == index
              ? AppColors.kPrimaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 20,
              color: screenIndex == index
                  ? AppColors.plainWhite
                  : AppColors.kPrimaryColor,
            ),
            // SizedBox(height: 0),
            Text(
              label,
              style: TextStyle(
                color: screenIndex == index
                    ? AppColors.plainWhite
                    : AppColors.kPrimaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
