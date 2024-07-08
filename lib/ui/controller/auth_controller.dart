import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/model/user_model.dart';

class AuthController {
  static String accessToken = '';
  static String accessTokenKey = 'access-token';
  static String emailKey = 'email';
  static String passwordKey = 'password';
  static String userDataKey = 'user-data';
  static UserModel? userData;

  static Future<void> saveUserAccessToken(String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(accessTokenKey, token);
    accessToken = token;
  }

  static Future<String?> getUserAccessToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(accessTokenKey);
  }

  static Future<void> saveUserData(UserModel user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(userDataKey, jsonEncode(user.toJson()));
    userData = user;
  }

  static Future<void> saveLoginData(String email, String password) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(emailKey, email);
    sharedPreferences.setString(passwordKey, password);
  }

  static Future<Map<String, dynamic>> getLoginData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? email = sharedPreferences.getString(emailKey);
    String? password = sharedPreferences.getString(passwordKey);
    return {'email': email, 'password': password};
  }

  static Future<UserModel?> getUserData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? data = sharedPreferences.getString(userDataKey);
    if (data == null) {
      return null;
    }
    return UserModel.fromJson(jsonDecode(data));
  }

  static Future<bool> checkAuthStatus() async {
    String? token = await getUserAccessToken();
    if (token == null) {
      return false;
    }
    accessToken = token;
    userData = await getUserData();
    return true;
  }

  static clearALlData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  static String get fullName => '${userData!.firstName} ${userData!.lastName}';
}
