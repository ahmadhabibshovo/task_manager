import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:regexpattern/regexpattern.dart';

import 'package:task_manager/routes.dart';

import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/utility/app_constant.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/snake_bar_message.dart';

import '../../controller/auth_controllers/sign_up_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailTEController = TextEditingController();
  final _firstNameTEController = TextEditingController();
  final _lastNameTEController = TextEditingController();
  final _mobileNoTEController = TextEditingController();
  final _passwordTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  final signUpController=Get.find<SignUpController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Join With Us",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your Email';
                        }
                        if (!AppConstant.emailRegExp.hasMatch(value!)) {
                          return 'Enter a Valid Email address';
                        }
                        return null;
                      },
                      controller: _emailTEController,
                      decoration: const InputDecoration(hintText: "Email"),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your First Name';
                        }
                        return null;
                      },
                      controller: _firstNameTEController,
                      decoration: const InputDecoration(hintText: "First Name"),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your Last Name';
                        }
                        return null;
                      },
                      controller: _lastNameTEController,
                      decoration: const InputDecoration(hintText: "Last Name"),
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
                      controller: _mobileNoTEController,
                      decoration: const InputDecoration(hintText: "Mobile"),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your Password';
                        }
                        return null;
                      },
                      controller: _passwordTEController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: Icon(!_showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          hintText: "Password"),
                      obscureText: _showPassword,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GetBuilder<SignUpController>(builder:(signUpController)=> Visibility(
                      visible:!signUpController.isSignUpProgress,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                          onPressed: () async {
                            onTapSignInButton();
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    ),),

                    const SizedBox(
                      height: 50,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Have account? ",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                              (){
                                onTapSignInText();
                              },

                            text: 'Sign in',
                            style: const TextStyle(color: AppColors.themeColor),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onTapSignInButton() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> requestInput = {
        "email": _emailTEController.text.trim(),
        "firstName": _firstNameTEController.text.trim(),
        "lastName": _lastNameTEController.text.trim(),
        "mobile": _mobileNoTEController.text.trim(),
        "password": _passwordTEController.text,
        "photo": "",
      };
      bool isaSuccess = await signUpController.signUp(requestInput);
      if(isaSuccess){
        Get.offAllNamed(Routes.signInScreenRoutes);
        showSnakeBarMessage(context, "Sign Up Successful !!!");
      }
      else{
        showSnakeBarMessage(context, signUpController.errorMessage,true);
      }
    }
  }
  onTapSignInText(){
    Get.offAllNamed(Routes.signInScreenRoutes);
  }





  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileNoTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
