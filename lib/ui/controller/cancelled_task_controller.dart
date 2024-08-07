import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/model/task_list_wrapper_model.dart';
import '../../data/model/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class CancelledTaskController extends GetxController{
  bool getCancelledTaskInProgress = false;
  List<TaskModel> cancelledTaskList = [];
  Future<void> getCancelledTasks() async {

    getCancelledTaskInProgress = true;
   update();
    NetworkResponse response = await NetworkCaller.getRequest(Urls.cancelledTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      cancelledTaskList = taskListWrapperModel.taskList ?? [];
    }
    getCancelledTaskInProgress = false;
   update();

  }

}