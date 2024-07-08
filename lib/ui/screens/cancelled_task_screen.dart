import 'package:flutter/material.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/model/task_list_wrapper_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snake_bar_message.dart';

import '../../data/model/task_model.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summery.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskInProgress = false;

  List<TaskModel> cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCancelledTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskSummery(),
          Expanded(
              child: RefreshIndicator(
            onRefresh: () async {
              _getCancelledTasks();
            },
            child: Visibility(
              visible: _getCancelledTaskInProgress == false,
              replacement: const CenteredProgressIndicator(),
              child: ListView.separated(
                  itemBuilder: (_, index) {
                    return TaskItem(
                      taskModel: cancelledTaskList[index],
                    );
                  },
                  separatorBuilder: (_, __) {
                    return const SizedBox(
                      height: 3,
                    );
                  },
                  itemCount: cancelledTaskList.length),
            ),
          ))
        ],
      ),
    );
  }

  Future<void> _getCancelledTasks() async {
    _getCancelledTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.cancelledTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      cancelledTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnakeBarMessage(
            context, 'Get cancelled task failed !! Try again', true);
      }
    }
    _getCancelledTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
