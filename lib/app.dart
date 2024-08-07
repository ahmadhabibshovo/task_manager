import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/bindings.dart';
import 'package:task_manager/routes.dart';
// ignore: unused_import
import 'package:task_manager/ui/screens/auth/splash_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';

class App extends StatefulWidget {
  const App({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBindings(),
      navigatorKey: App.navigatorKey,
      title: 'Flutter Demo',
      theme: lightThemeData,
      initialRoute: Routes.splashScreenRoutes,
      getPages: Routes.routes,
    );
  }
}

ThemeData lightThemeData = ThemeData(
  textTheme: TextTheme(
      titleLarge: const TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
      titleSmall: TextStyle(
        color: Colors.grey.shade600,
      )),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
          textStyle: const TextStyle(fontWeight: FontWeight.w600))),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(color: Colors.grey),
    border: OutlineInputBorder(borderSide: BorderSide.none),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromWidth(double.maxFinite),
          backgroundColor: AppColors.themeColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          foregroundColor: AppColors.foregroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);
