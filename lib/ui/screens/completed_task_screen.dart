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

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskInProgress = false;

  List<TaskModel> completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTasks();
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
              _getCompletedTasks();
            },
            child: Visibility(
              visible: _getCompletedTaskInProgress == false,
              replacement: const CenteredProgressIndicator(),
              child: ListView.separated(
                  itemBuilder: (_, index) {
                    return TaskItem(
                      taskModel: completedTaskList[index],
                    );
                  },
                  separatorBuilder: (_, __) {
                    return const SizedBox(
                      height: 3,
                    );
                  },
                  itemCount: completedTaskList.length),
            ),
          ))
        ],
      ),
    );
  }

  Future<void> _getCompletedTasks() async {
    _getCompletedTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.completedTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      completedTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnakeBarMessage(
            context, 'Get completed task failed !! Try again', true);
      }
    }
    _getCompletedTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
