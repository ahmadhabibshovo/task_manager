import 'package:get/get.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/controller/task_summery_controller.dart';
import '../../data/model/network_response.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class AddNewTaskController extends GetxController{
  bool addNewTaskInProgress = false;
  Future<bool> addNewTasks(String title,String description) async {
bool isSuccess =false;
    addNewTaskInProgress = true;
   update();
    Map<String, dynamic> requestData = {
      'title':title,
      'description': description,
      'status': 'New',
    };
    NetworkResponse response =
    await NetworkCaller.postRequest(Urls.createTask, body: requestData);
    if (response.isSuccess) {
     isSuccess =true;
     Get.find<NewTaskController>().getNewTasks();
     Get.find<TaskSummeryController>().getTaskCountByStatus();

    }
    addNewTaskInProgress = false;
   update();
 return isSuccess;
  }
  
}