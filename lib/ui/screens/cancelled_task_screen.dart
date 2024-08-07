import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';

import '../controller/cancelled_task_controller.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summery.dart';
class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  final cancelledTaskController=Get.find<CancelledTaskController>();

  @override
  void initState() {
    cancelledTaskController.getCancelledTasks();
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
              child: GetBuilder<CancelledTaskController>(builder: (cancelledTaskController){
                return  Visibility(
                  visible: !cancelledTaskController.getCancelledTaskInProgress,
                  replacement: const CenteredProgressIndicator(),
                  child: ListView.separated(
                      itemBuilder: (_, index) {
                        return TaskItem(
                          taskModel: cancelledTaskController.cancelledTaskList[index],selectedIndex: 3,
                        );
                      },
                      separatorBuilder: (_, __) {
                        return const SizedBox(
                          height: 3,
                        );
                      },
                      itemCount:cancelledTaskController.cancelledTaskList.length),
                );
              },),
            )
          ],
        ));
  }


}
