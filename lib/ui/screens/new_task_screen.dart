import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';



import '../widgets/task_item.dart';
import '../widgets/task_summery.dart';

class NewTaskScreen extends StatefulWidget {
   const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();

}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final newTaskController=Get.find<NewTaskController>();
@override
  void initState() {
    newTaskController.getNewTasks();
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
              child: GetBuilder<NewTaskController>(builder: (newTaskController){
                return  Visibility(
                  visible: !newTaskController.getNewTaskInProgress,
                  replacement: const CenteredProgressIndicator(),
                  child: ListView.separated(
                      itemBuilder: (_, index) {
                        return TaskItem(
                          taskModel: newTaskController.newTaskList[index],selectedIndex: 0,
                        );
                      },
                      separatorBuilder: (_, __) {
                        return const SizedBox(
                          height: 3,
                        );
                      },
                      itemCount:newTaskController.newTaskList.length),
                );
              },),
            )
          ],
        ));
  }


}
