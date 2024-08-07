import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/routes.dart';

import 'package:task_manager/ui/controller/auth_controllers/sign_in_controller.dart';

import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/snake_bar_message.dart';


import '../../utility/app_constant.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailTEController = TextEditingController();

  final _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final signInController=Get.find<SignInController>();

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
                      "Get Started With",
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
                          return 'Enter your Password';
                        }
                        return null;
                      },
                      controller: _passwordTEController,
                      decoration: const InputDecoration(hintText: "Password"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GetBuilder<SignInController>(builder: (signInController)=>Visibility(
                      visible: !signInController.isSignInProgress,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                          onPressed: onTapNextButton,
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    )),
                    const SizedBox(
                      height: 50,
                    ),
                    TextButton(
                        onPressed: onTapForgetPasswordButton,
                        child: const Text("Forget Password?")),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = onTapSignUpButton,
                            text: 'Sign up',
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

  onTapSignUpButton() {
    Get.offAllNamed(Routes.signUpScreenRoutes);
  }

  onTapForgetPasswordButton() {
    Get.offAllNamed(Routes.emailVerificationScreenRoutes);
  }

  onTapNextButton() async {
    if (_formKey.currentState!.validate()) {
   bool isSuccess = await signInController.signIn(_emailTEController.text, _passwordTEController.text);
   if(isSuccess){
     showSnakeBarMessage(context, "Login Successful !!!");
     Get.offAllNamed(Routes.mainNavScreenRoutes);
   }
   else{
     showSnakeBarMessage(context, signInController.errorMessage,true);
   }

    }
  }



  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
