import 'package:get/get.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/controller/auth_controllers/auth_controller.dart';

import '../../../data/model/login_response.dart';
import '../../../data/model/network_response.dart';
import '../../../data/utilities/urls.dart';


class SignInController extends GetxController{

   bool isSignInProgress = false;
   String? _errorMessage;
   String get  errorMessage => _errorMessage ?? "Sign In Failed Try Again !!!" ;
  Future<bool> signIn(String email,String password) async {
    bool isSuccess = false;
    isSignInProgress = true;
    update();
    Map<String, dynamic> requestData = {
      'email': email.trim(),
      'password': password
    };
    final NetworkResponse networkResponse =
    await NetworkCaller.postRequest(Urls.login, body: requestData);
    isSignInProgress = false;
   update();
    if (networkResponse.isSuccess) {
    isSuccess=true;
      LoginResponse loginResponse =
      LoginResponse.fromJson(networkResponse.responseData);
      await AuthController.saveUserAccessToken(loginResponse.token!);
      await AuthController.saveUserData(loginResponse.userModel!);

    } else {
      _errorMessage = networkResponse.errorMessage;
    }
    return isSuccess;
  }
}