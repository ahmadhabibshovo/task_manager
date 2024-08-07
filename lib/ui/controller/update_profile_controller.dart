import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class UpdateProfileController extends GetxController{

  bool updateProfileInProgress = false;

  Future<bool> updateProfile( Map<String, dynamic> requestBody) async {
    bool isSuccess=false;
    updateProfileInProgress = true;

    update();

    NetworkResponse response =
    await NetworkCaller.postRequest(Urls.updateProfile, body: requestBody);
    updateProfileInProgress = false;
    update();
    if (response.isSuccess) {
      isSuccess =true;
    }
    return isSuccess;
  }
}