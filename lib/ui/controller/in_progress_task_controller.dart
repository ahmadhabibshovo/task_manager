import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/model/task_list_wrapper_model.dart';
import '../../data/model/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class InProgressTaskController extends GetxController{
  bool getInProgressTaskInProgress = false;
  List<TaskModel> inProgressTaskList = [];
  Future<void> getInProgressTasks() async {

    getInProgressTaskInProgress = true;
   update();
    NetworkResponse response = await NetworkCaller.getRequest(Urls.inProgressTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      inProgressTaskList = taskListWrapperModel.taskList ?? [];
    }
    getInProgressTaskInProgress = false;
   update();

  }

}