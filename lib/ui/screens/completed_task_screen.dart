import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';



import '../controller/completed_task_controller.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summery.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();

}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final completedTaskController=Get.find<CompletedTaskController>();
  @override

  void initState() {
   completedTaskController.getCompletedTasks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TaskSummery(),
            Expanded(
              child: GetBuilder<CompletedTaskController>(builder: (completedTaskController){
                return  Visibility(
                  visible: !completedTaskController.getCompletedTaskInProgress,
                  replacement: const CenteredProgressIndicator(),
                  child: ListView.separated(
                      itemBuilder: (_, index) {
                        return TaskItem(
                          taskModel: completedTaskController.completedTaskList[index],selectedIndex: 1,
                        );
                      },
                      separatorBuilder: (_, __) {
                        return const SizedBox(
                          height: 3,
                        );
                      },
                      itemCount:completedTaskController.completedTaskList.length),
                );
              },),
            )
          ],
        ));
  }


}
