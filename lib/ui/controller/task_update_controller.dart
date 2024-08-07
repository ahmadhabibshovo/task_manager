import 'package:get/get.dart';
import 'package:task_manager/ui/controller/task_summery_controller.dart';

import '../../data/model/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../screens/main_bottom_nav_screen.dart';
import 'cancelled_task_controller.dart';
import 'completed_task_controller.dart';
import 'in_progress_task_controller.dart';
import 'new_task_controller.dart';

class TaskUpdateController extends GetxController{
  bool taskUpdateInProgress=false;
  taskStatusUpdate(String status, String id,int selectedIndex) async {
    taskUpdateInProgress=true;
    update();

    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.updateTaskStatues(status, id));
    taskUpdateInProgress=false;
    update();
    if (response.isSuccess) {
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


  }
}