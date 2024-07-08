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

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _getInProgressTaskInProgress = false;

  List<TaskModel> inProgressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getInProgressTasks();
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
              _getInProgressTasks();
            },
            child: Visibility(
              visible: _getInProgressTaskInProgress == false,
              replacement: const CenteredProgressIndicator(),
              child: ListView.separated(
                  itemBuilder: (_, index) {
                    return TaskItem(
                      taskModel: inProgressTaskList[index],
                    );
                  },
                  separatorBuilder: (_, __) {
                    return const SizedBox(
                      height: 3,
                    );
                  },
                  itemCount: inProgressTaskList.length),
            ),
          ))
        ],
      ),
    );
  }

  Future<void> _getInProgressTasks() async {
    _getInProgressTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.inProgressTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      inProgressTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnakeBarMessage(
            context, 'Get InProgress task failed !! Try again', true);
      }
    }
    _getInProgressTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
