import 'package:get/get.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager/ui/screens/auth/otp_verification_screen.dart';
import 'package:task_manager/ui/screens/auth/set_password_screen.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/screens/auth/splash_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

import 'ui/screens/auth/sign_up_screen.dart';

class Routes{
   static const String _splashScreen = '/splashScreen';
  static const String _signInScreen = '/signInScreen';
   static const String _signUpScreen = '/signUpScreen';
  static const String _mainNavScreen = '/mainNavScreen';
  static const String _emailVerificationScreen = '/emailVerificationScreen';
  static const String _otpVerificationScreen = '/otpVerificationScreen';
  static const String _setPasswordScreen = '/setPasswordScreen';
  static const String _updateProfileScreen = '/updateProfileScreen';
  static const String _addNewTaskScreen = '/addNewTaskScreen';
 static String _email='';
 static String _otp='';
  static String get splashScreenRoutes => _splashScreen;
  static String get addNewTaskScreen => _addNewTaskScreen;
  static String get signInScreenRoutes => _signInScreen;
  static String get signUpScreenRoutes => _signUpScreen;
  static String get mainNavScreenRoutes => _mainNavScreen;
  static String get updateProfileScreen => _updateProfileScreen;
  static String get emailVerificationScreenRoutes => _emailVerificationScreen;
  static String  otpVerificationScreenRoutes (
      String email
      ){
    _email =email;
    return _otpVerificationScreen;
  }
   static String  setPasswordScreenRoutes (
       String otp
       ){
     _otp =otp;
     return _setPasswordScreen;
   }

static List<GetPage>  routes=[
  GetPage(name: _splashScreen, page: ()=> const SplashScreen() ,transition:  Transition.zoom),
  GetPage(name: _signInScreen, page: ()=> const SignInScreen() ,transition:  Transition.leftToRightWithFade),
  GetPage(name: _signUpScreen, page: ()=> const SignUpScreen() ,transition:  Transition.leftToRightWithFade),
  GetPage(name: _mainNavScreen, page: ()=> const MainBottomNavScreen() ,transition:  Transition.zoom),
  GetPage(name: _addNewTaskScreen, page: ()=> const AddNewTaskScreen() ,transition:  Transition.zoom),
  GetPage(name: _updateProfileScreen, page: ()=> const UpdateProfileScreen() ,transition:  Transition.zoom),
  GetPage(name: _emailVerificationScreen, page: ()=> const EmailVerificationScreen() ,transition:  Transition.zoom),
  GetPage(name: _otpVerificationScreen, page: ()=>  OTPVerificationScreen(email: _email) ,transition:  Transition.zoom),
  GetPage(name: _setPasswordScreen, page: ()=>  SetPasswordScreen(email: _email, otp: _otp) ,transition:  Transition.zoom),
];
}