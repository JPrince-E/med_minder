// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:med_minder/app/resources/app.logger.dart';
import 'package:med_minder/ui/shared/spacer.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';
import 'package:med_minder/utils/app_constants/app_styles.dart';
import 'package:med_minder/utils/app_constants/app_sub_strings.dart';
import 'package:med_minder/utils/screen_util/screen_util.dart';

var log = getLogger('SplashScreen');

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation? sizeAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();

    sizeAnimation = Tween(begin: 20.0, end: 50.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.0, 0.5),
      ),
    );

    // Delay navigation action until after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateToSignInView();
    });
  }

  void navigateToSignInView() {
    // Use GoRouter to navigate to the signInView
    GoRouter.of(context).go('/signInView');
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.lighterGray,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.lighterGray,
      ),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '',
                style: AppStyles.subStringStyle(
                    sizeAnimation!.value * 0.3, AppColors.plainWhite),
              ),
              Center(
                child: AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/images/med.png'),
                          height: sizeAnimation!.value * 4,
                          width: sizeAnimation!.value * 4,
                        ),
                        CustomSpacer(screenSize(context).height / 100),
                        Text(
                          "",
                          style: AppStyles.defaultKeyStringStyle(
                            sizeAnimation!.value * 0.75,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Text(
                AppSubStrings.yearFUTA,
                style: AppStyles.subStringStyle(16, AppColors.kPrimaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
