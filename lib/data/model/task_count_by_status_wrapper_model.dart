import 'package:task_manager/data/model/task_by_status_model.dart';

class TaskCountByStatusWrapperModel {
  String? status;
  List<TaskByStatusModel>? taskCountByStatusList;

  TaskCountByStatusWrapperModel({this.status, this.taskCountByStatusList});

  TaskCountByStatusWrapperModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskCountByStatusList = <TaskByStatusModel>[];
      json['data'].forEach((v) {
        taskCountByStatusList!.add(TaskByStatusModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (taskCountByStatusList != null) {
      data['data'] = taskCountByStatusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
