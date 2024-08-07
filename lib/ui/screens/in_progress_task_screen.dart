import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';

import '../controller/in_progress_task_controller.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summery.dart';
class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();

}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  final inProgressTaskController=Get.find<InProgressTaskController>();
  @override
  void initState() {
  inProgressTaskController.getInProgressTasks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskSummery(),
            Expanded(
              child: GetBuilder<InProgressTaskController>(builder: (inProgressTaskController){
                return  Visibility(
                  visible: !inProgressTaskController.getInProgressTaskInProgress,
                  replacement: const CenteredProgressIndicator(),
                  child: ListView.separated(
                      itemBuilder: (_, index) {
                        return TaskItem(
                          taskModel: inProgressTaskController.inProgressTaskList[index],selectedIndex: 2,
                        );
                      },
                      separatorBuilder: (_, __) {
                        return const SizedBox(
                          height: 3,
                        );
                      },
                      itemCount:inProgressTaskController.inProgressTaskList.length),
                );
              },),
            )
          ],
        ));
  }


}
