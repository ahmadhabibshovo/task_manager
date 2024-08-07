import 'package:get/get.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';


class SignUpController extends GetxController{

   bool isSignUpProgress = false;
   String? _errorMessage;
   String get  errorMessage => _errorMessage ?? "Sign Up Failed Try Again !!!" ;
  Future<bool> signUp(Map<String, dynamic> requestInput ) async {
    bool isSuccess = false;
    isSignUpProgress = true;
    update();

    NetworkResponse networkResponse =
    await NetworkCaller.postRequest(Urls.registration, body: requestInput);
    isSignUpProgress = false;
   update();
    if (networkResponse.isSuccess) {
    isSuccess=true;


    } else {
      _errorMessage = networkResponse.errorMessage;
    }
    return isSuccess;
  }
}
