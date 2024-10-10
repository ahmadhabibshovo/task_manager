import 'package:task_manager/data/model/user_model.dart';

class LoginResponse {
  String? status;
  List<UserModel>? userModel;
  String? token;

  LoginResponse({this.status, this.userModel, this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      userModel = <UserModel>[];
      json['data'].forEach((v) {
        userModel!.add(new UserModel.fromJson(v));
      });
    }
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.userModel != null) {
      data['data'] = this.userModel!.map((v) => v.toJson()).toList();
    }
    data['token'] = this.token;
    return data;
  }
}
