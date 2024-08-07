import 'package:get/get.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/controller/cancelled_task_controller.dart';
import 'package:task_manager/ui/controller/completed_task_controller.dart';
import 'package:task_manager/ui/controller/in_progress_task_controller.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/controller/task_summery_controller.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';

import '../../data/model/network_response.dart';
import '../../data/utilities/urls.dart';

class DeleteTaskController extends GetxController{

  bool deleteInProgress = false;
  deleteTask(String id ,int selectedIndex) async {
    deleteInProgress = true;
    update();
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.deleteTask(id));
    if(response.isSuccess){
      Get.find<TaskSummeryController>().getTaskCountByStatus();
      switch (selectedIndex){
        case 0:
          Get.find<NewTaskController>().getNewTasks();
          break;
        case 1:
          Get.find<CompletedTaskController>().getCompletedTasks();
          break;
        case 2:
          Get.find<InProgressTaskController>().getInProgressTasks();
          break;
        case 3:
          Get.find<CancelledTaskController>().getCancelledTasks();
          break;
      }
     Get.offAll(MainBottomNavScreen(selectedIndex: selectedIndex,));

    }
    deleteInProgress = false;
   update();


  }

}