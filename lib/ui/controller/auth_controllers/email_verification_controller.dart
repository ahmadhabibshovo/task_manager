import 'package:get/get.dart';

import '../../../data/model/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';


class EmailVerificationController extends GetxController{

  bool verifyEmailInProgress = false;
  String? _errorMessage;
  String get  errorMessage => _errorMessage ?? " Email Verification Failed Try Again !!!" ;
  Future<bool> emailValidate(String email) async {
    bool isSuccess=false;
    verifyEmailInProgress = true;
    update();
    NetworkResponse response = await NetworkCaller.getRequest(
        Urls.recoverVerifyEmail(email.trim()));
    if (response.isSuccess) {
     isSuccess=true;
      }
    else {
      _errorMessage = response.errorMessage;
    }
    verifyEmailInProgress = false;
    update();
    return isSuccess;
  }
}