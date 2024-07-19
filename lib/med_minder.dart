import 'package:flutter/material.dart';
import 'package:med_minder/app/resources/app.router.dart';
import 'package:med_minder/app/services/navigation_service.dart';
import 'package:med_minder/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:med_minder/utils/app_constants/app_theme_data.dart';
import 'package:provider/provider.dart';

class MedMinder extends StatelessWidget {
  MedMinder({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrentPage(),
      child: MaterialApp.router(
        /// MaterialApp params
        title: "Med Minder",
        scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: appThemeData,

        /// GoRouter specific params
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      ),
    );
  }

  // BuildContext? get ctx => _router.routerDelegate.navigatorKey.currentContext;
  final _router = AppRouter.router;
}
