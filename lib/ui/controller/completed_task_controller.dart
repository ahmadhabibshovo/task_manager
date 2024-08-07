import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/model/task_list_wrapper_model.dart';
import '../../data/model/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class CompletedTaskController extends GetxController{
  bool getCompletedTaskInProgress = false;
  List<TaskModel> completedTaskList = [];
  Future<void> getCompletedTasks() async {

    getCompletedTaskInProgress = true;
   update();
    NetworkResponse response = await NetworkCaller.getRequest(Urls.completedTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      completedTaskList = taskListWrapperModel.taskList ?? [];
    }
    getCompletedTaskInProgress = false;
   update();

  }

}