class TaskByStatusModel {
  String? sId;
  int? sum;

  TaskByStatusModel({this.sId, this.sum});

  TaskByStatusModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['sum'] = sum;
    return data;
  }
}
