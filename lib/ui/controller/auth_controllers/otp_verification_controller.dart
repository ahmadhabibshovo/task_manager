
import 'package:get/get.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';



class OTPVerificationController extends GetxController{

  bool verifyOTPInProgress = false;
  String? _errorMessage;
  String get  errorMessage => _errorMessage ?? " OTP Verification Failed Try Again !!!" ;
  Future<bool> otpValidate(String otp,String email) async {
    bool isSuccess=false;
    verifyOTPInProgress = true;
    update();
    NetworkResponse response = await NetworkCaller.getRequest(
        Urls.recoverVerifyOtp(otp, email));
    if (response.isSuccess) {
     isSuccess=true;
      }
    else {
      _errorMessage = response.errorMessage;
    }
    verifyOTPInProgress = false;
    update();
    return isSuccess;
  }
}
