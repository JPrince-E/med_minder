import 'package:flutter/material.dart';
import 'package:med_minder/app/resources/app.router.dart';
import 'package:med_minder/app/services/navigation_service.dart';
import 'package:med_minder/ui/features/create_account/login_controller/login_controller.dart';
import 'package:med_minder/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:med_minder/utils/app_constants/app_theme_data.dart';
import 'package:provider/provider.dart';

class MedMinder extends StatelessWidget {
  final String? savedUsername;
  final String? savedPassword;

  MedMinder({
    super.key,
    this.savedUsername,
    this.savedPassword,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrentPage(),
      child: MaterialApp.router(
        title: "Med Minder",
        scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: appThemeData,
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        builder: (context, child) {
          return FutureBuilder(
            future: _handleAutoLogin(context),
            builder: (context, snapshot) {
              // While checking for saved credentials, show a splash screen or loading indicator
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              // Once the check is done, show the appropriate screen
              return child!;
            },
          );
        },
      ),
    );
  }

  Future<void> _handleAutoLogin(BuildContext context) async {
    if (savedUsername != null && savedPassword != null) {
      // Perform automatic login
      final loginController = Provider.of<LoginController>(context, listen: false);
      loginController.usernameController.text = savedUsername!;
      loginController.passwordController.text = savedPassword!;
      await loginController.signInUser(context);
    }
  }

  final _router = AppRouter.router;
}