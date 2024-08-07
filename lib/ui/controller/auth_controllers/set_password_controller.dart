
import 'package:get/get.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';



class SetPasswordController extends GetxController{

  bool setPasswordInProgress = false;
  String? _errorMessage;
  String get  errorMessage => _errorMessage ?? " reset password Failed Try Again !!!" ;
  Future<bool> setPassword(String otp,String email,String password) async {
    bool isSuccess=false;
    setPasswordInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email":email,
      "OTP": otp,
      "password": password
    };

    NetworkResponse response = await NetworkCaller.postRequest(
        Urls.recoverResetPassWord,
        body: requestBody);
    if (response.isSuccess) {
      isSuccess=true;
    }
    else {
      _errorMessage = response.errorMessage;
    }
    setPasswordInProgress = false;
    update();
    return isSuccess;
  }
}
