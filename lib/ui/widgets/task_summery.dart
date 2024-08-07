import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/task_summery_controller.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/task_summery_card.dart';



class TaskSummery extends StatefulWidget {
 const  TaskSummery({
    super.key,
  });

  @override
  State<TaskSummery> createState() => _TaskSummeryState();
}

class _TaskSummeryState extends State<TaskSummery> {
  final taskSummeryController= Get.find<TaskSummeryController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    taskSummeryController.getTaskCountByStatus();
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskSummeryController>(builder: (taskSummeryController){
      return Visibility(
        visible: !taskSummeryController.getTaskCountByStatusInProgress,
        replacement: const CenteredProgressIndicator(),
        child: Row(
          children: [
            Expanded(
              child: FittedBox(
                child: TaskSummaryCard(
                    title: "New Task", count: taskSummeryController.getSummeryCount('New')),
              ),
            ),
            Expanded(
              child: FittedBox(
                child: TaskSummaryCard(
                    title: "Completed", count:  taskSummeryController.getSummeryCount('Completed')),
              ),
            ),
            Expanded(
              child: FittedBox(
                child: TaskSummaryCard(
                    title: "In Progress", count: taskSummeryController.getSummeryCount('InProgress')),
              ),
            ),
            Expanded(
              child: FittedBox(
                child: TaskSummaryCard(
                    title: "Cancelled", count: taskSummeryController.getSummeryCount('Cancelled')),
              ),
            )
          ],
        ),
      );
    });
  }


}
