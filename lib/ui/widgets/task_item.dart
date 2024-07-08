import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snake_bar_message.dart';

import '../../data/model/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../screens/main_bottom_nav_screen.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.taskModel,
  });

  final TaskModel taskModel;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteInProgress = false;
  bool _taskStatusUpdateInProgress = false;

  @override
  Widget build(BuildContext context) {
    String? dropdownValue = widget.taskModel.status;
    return Card(
      child: ListTile(
        title: Text(widget.taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.description ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              widget.taskModel.createdDate!,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(widget.taskModel.status ?? 'New'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                ButtonBar(
                  children: [
                    Visibility(
                      visible: _deleteInProgress == false,
                      replacement: CenteredProgressIndicator(),
                      child: IconButton(
                          onPressed: () {
                            deleteTask(widget.taskModel.sId!);
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (newValue) {
                        dropdownValue = newValue;
                        _taskStatusUpdate(
                            dropdownValue!, widget.taskModel.sId!);
                      },
                      items: <String>[
                        'New',
                        'Completed',
                        'InProgress',
                        'Cancelled'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  deleteTask(String id) async {
    _deleteInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.deleteTask(id));
    if (response.isSuccess) {
      if (mounted) {
        showSnakeBarMessage(context, 'Successfully Deleted');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => MainBottomNavScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        showSnakeBarMessage(context, 'Something wrong !! Try again', true);
      }
    }
    _deleteInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  _taskStatusUpdate(String status, String id) async {
    _taskStatusUpdateInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.updateTaskStatues(status, id));
    if (response.isSuccess) {
      if (mounted) {
        showSnakeBarMessage(context, 'Status Successfully Updated');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => MainBottomNavScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        showSnakeBarMessage(context, 'Something wrong !! Try again', true);
      }
    }
    _taskStatusUpdateInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
