import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/model/task_by_status_model.dart';
import '../../data/model/task_count_by_status_wrapper_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';



class TaskSummeryController extends GetxController{
  bool getTaskCountByStatusInProgress = false;

  List<TaskByStatusModel> taskCountByStatusList = [];
  String getSummeryCount(String element) {
    for (final task in taskCountByStatusList) {
    }
    final taskCount =
    taskCountByStatusList.where((e) => e.sId == element).toList();
    return taskCount.isEmpty ? '0' : taskCount.first.sum.toString();
  }

  Future<void> getTaskCountByStatus() async {
    getTaskCountByStatusInProgress = true;
   update();
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
      TaskCountByStatusWrapperModel.fromJson(response.responseData);
      taskCountByStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    }
    getTaskCountByStatusInProgress = false;
    update();
  }
}