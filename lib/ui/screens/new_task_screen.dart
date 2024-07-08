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

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskInProgress = false;

  List<TaskModel> newTaskList = [];

  @override
  void initState() {
    super.initState();
    _getNewTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        _getNewTasks();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskSummery(),
          Expanded(
            child: Visibility(
              visible: _getNewTaskInProgress == false,
              replacement: const CenteredProgressIndicator(),
              child: ListView.separated(
                  itemBuilder: (_, index) {
                    return TaskItem(
                      taskModel: newTaskList[index],
                    );
                  },
                  separatorBuilder: (_, __) {
                    return const SizedBox(
                      height: 3,
                    );
                  },
                  itemCount: newTaskList.length),
            ),
          )
        ],
      ),
    ));
  }

  Future<void> _getNewTasks() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnakeBarMessage(context, 'Get new task failed !! Try again', true);
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
