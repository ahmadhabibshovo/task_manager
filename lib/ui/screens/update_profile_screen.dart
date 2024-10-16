import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:task_manager/ui/controller/update_profile_controller.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/profile_appbar_widget.dart';

import '../../routes.dart';
import '../controller/auth_controllers/auth_controller.dart';
import '../utility/app_constant.dart';
import '../widgets/snake_bar_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _emailTEController = TextEditingController();
  final _firstNameTEController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileTEController = TextEditingController();
  final _passwordTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
final updateProfileController = Get.find<UpdateProfileController>();

  @override
  void initState() {
    final userData = AuthController.userData!;
    _emailTEController.text = userData.email ?? '';
    _firstNameTEController.text = userData.firstName ?? '';
    _lastNameController.text = userData.lastName ?? '';
    _mobileTEController.text = userData.mobile ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context, true),
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildPhotoPickerWidget(),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Email';
                      }
                      if (!AppConstant.emailRegExp.hasMatch(value!)) {
                        return 'Enter a Valid Email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  TextFormField(
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your First Name';
                      }
                      return null;
                    },
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(hintText: 'First Name'),
                  ),
                  TextFormField(
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Last Name';
                      }
                      return null;
                    },
                    controller: _lastNameController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Mobile Number';
                      }
                      if (!(value!.isPhone())) {
                        return 'Enter a Valid Mobile Number';
                      }
                      return null;
                    },
                    controller: _mobileTEController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Mobile'),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  GetBuilder<UpdateProfileController>(builder: (updateProfileController){
                    return Visibility(
                      visible: !updateProfileController.updateProfileInProgress,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _onPressUpdateButton();
                            }
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    );
                  })
                  ,
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildPhotoPickerWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 100,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: InkWell(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                _selectedImage =
                    await picker.pickImage(source: ImageSource.camera,imageQuality: 1);
                setState(() {});
              },
              child: const Text(
                'Photo',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_selectedImage == null
                ? 'No Image Selected'
                : 'Image is Selected'),
          ))
        ],
      ),
    );
  }



void _onPressUpdateButton()async{
  Map<String, dynamic> requestBody = {
    'email': _emailTEController.text,
    'firstName': _firstNameTEController.text,
    'lastName': _lastNameController.text,
    'mobile': _mobileTEController.text,
  };
  if (_passwordTEController.text.isNotEmpty) {
    requestBody['password'] = _passwordTEController.text;
  }
  if (_selectedImage != null) {
    File imageFile = File(_selectedImage!.path);
    requestBody['photo'] = base64Encode(imageFile.readAsBytesSync());
  }
  bool     isSuccess=await updateProfileController.updateProfile(requestBody);
  if (isSuccess) {
    if(mounted){
    showSnakeBarMessage(context, 'Profile Successfully Updated!!');}
   Get.defaultDialog(
     title: "Logout",
     content: const Text("if you login again your update will be apply"),
     textCancel: 'Cancel',
       textConfirm: 'Logout',
       confirmTextColor: Colors.red,
       onCancel: (){
         Get.offAllNamed(Routes.mainNavScreenRoutes);
       },
       onConfirm: (){
         Get.offAllNamed(Routes.signInScreenRoutes);
         AuthController.clearALlData();
    }




   );

  }
 else {
  if (mounted) {
  showSnakeBarMessage(context, 'Profile Update failed try Again!!', true);
  }
 }

}


}
