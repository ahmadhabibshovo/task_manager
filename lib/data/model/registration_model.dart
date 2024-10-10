class RegistrationModel {
  RegistrationModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.password,
  });
  late final String email;
  late final String firstName;
  late final String lastName;
  late final String mobile;
  late final String password;

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['mobile'] = mobile;
    _data['password'] = password;
    return _data;
  }
}
