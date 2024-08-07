import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/ui/controller/delete_task_controller.dart';
import 'package:task_manager/ui/controller/task_update_controller.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';


class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.taskModel, required this.selectedIndex,
  });

  final TaskModel taskModel;
final int selectedIndex;
  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {


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
                    GetBuilder<DeleteTaskController>(builder: (deleteTaskController){
                      return Visibility(
                        visible: !deleteTaskController.deleteInProgress,
                        replacement: const CenteredProgressIndicator(),
                        child: IconButton(
                            onPressed: () {
                              deleteTaskController.deleteTask(widget.taskModel.sId!,widget.selectedIndex);
                            },
                            icon: const Icon(Icons.delete)),
                      );
                    }),
    GetBuilder<TaskUpdateController>(builder: (taskUpdateController){
    return Visibility(
    visible: !taskUpdateController.taskUpdateInProgress,
    replacement: const CenteredProgressIndicator(),
    child: PopupMenuButton<String>(
      onSelected: (newValue) {
        dropdownValue = newValue;
        taskUpdateController.taskStatusUpdate(dropdownValue!, widget.taskModel.sId!,widget.selectedIndex);
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'New',
            child: Text('New'),
          ),
          const PopupMenuItem<String>(
            value: 'Completed',
            child: Text('Completed'),
          ),
          const PopupMenuItem<String>(
            value: 'InProgress',
            child: Text('InProgress'),
          ),
          const PopupMenuItem<String>(
            value: 'Cancelled',
            child: Text('Cancelled'),
          ),
        ];
      },
      child: const Icon(Icons.edit), // Replace with your desired button child
    )
    );
    }),

                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }




}
