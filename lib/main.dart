import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:time_tracker/app/controller/vacation_controller.dart';
import 'package:time_tracker/app/screens/auth/dashboard_screen.dart';
import 'package:time_tracker/app/screens/auth/login_screen.dart';
import 'package:time_tracker/app/routing/transition_route_observer.dart';
import 'package:time_tracker/app/screens/profile/profile.dart';
import 'package:time_tracker/app/screens/history/olderDay.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  if (GetPlatform.isMobile) {
    HttpOverrides.global = MyHttpOverrides();
  }
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(324, 46, 59, 0.4),
    ),
  );
  Get.put(VacationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Login Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(324, 46, 59, 0.4),
        unselectedWidgetColor: Colors.grey,
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.grey),
        // fontFamily: 'SourceSansPro',
        // ignore: prefer_const_constructors
        textTheme: TextTheme(
          displaySmall: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            // fontWeight: FontWeight.w400,
            color: Colors.green,
          ),
          labelLarge: const TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          bodySmall: const TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.pink,
          ),
          displayLarge: const TextStyle(fontFamily: 'Quicksand'),
          displayMedium: const TextStyle(fontFamily: 'Quicksand'),
          headlineMedium: const TextStyle(fontFamily: 'Quicksand'),
          headlineSmall: const TextStyle(fontFamily: 'NotoSans'),
          titleLarge: const TextStyle(fontFamily: 'NotoSans'),
          titleMedium: const TextStyle(fontFamily: 'NotoSans'),
          bodyLarge: const TextStyle(fontFamily: 'NotoSans'),
          bodyMedium: const TextStyle(fontFamily: 'NotoSans'),
          titleSmall: const TextStyle(fontFamily: 'NotoSans'),
          labelSmall: const TextStyle(fontFamily: 'NotoSans'),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(secondary: Colors.orange)
            .copyWith(background: Color.fromRGBO(324, 46, 59, 0.4)),
      ),
      navigatorObservers: [TransitionRouteObserver()],
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        DashboardScreen.routeName: (context) => const DashboardScreen(),
        Profile.routeName: (context) => Profile(),
        OlderDay.routeName: (context) => OlderDay(),
      },
    );
  }
}
