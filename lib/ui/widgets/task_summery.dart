import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_by_status_model.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snake_bar_message.dart';
import 'package:task_manager/ui/widgets/task_summery_card.dart';

import '../../data/model/network_response.dart';
import '../../data/model/task_count_by_status_wrapper_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class TaskSummery extends StatefulWidget {
  TaskSummery({
    super.key,
  });

  @override
  State<TaskSummery> createState() => _TaskSummeryState();
}

class _TaskSummeryState extends State<TaskSummery> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getTaskCountByStatus();
  }

  bool _getTaskCountByStatusInProgress = false;

  List<TaskByStatusModel> _taskCountByStatusList = [];

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _getTaskCountByStatusInProgress == false,
      replacement: CenteredProgressIndicator(),
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              child: TaskSummaryCard(
                  title: "New Task", count: _getSummeryCount('New')),
            ),
          ),
          Expanded(
            child: FittedBox(
              child: TaskSummaryCard(
                  title: "Completed", count: _getSummeryCount('Completed')),
            ),
          ),
          Expanded(
            child: FittedBox(
              child: TaskSummaryCard(
                  title: "In Progress", count: _getSummeryCount('InProgress')),
            ),
          ),
          Expanded(
            child: FittedBox(
              child: TaskSummaryCard(
                  title: "Cancelled", count: _getSummeryCount('Cancelled')),
            ),
          )
        ],
      ),
    );
  }

  String _getSummeryCount(String element) {
    for (final task in _taskCountByStatusList) {
      print(task.sId);
    }
    final taskCount =
        _taskCountByStatusList.where((e) => e.sId == element).toList();
    return taskCount.length == 0 ? '0' : taskCount.first.sum.toString();
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
          TaskCountByStatusWrapperModel.fromJson(response.responseData);
      _taskCountByStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
      if (mounted) {
        showSnakeBarMessage(
            context, 'Get Task Status failed !! Try again', true);
      }
    }
    _getTaskCountByStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
