import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';


import '../../../routes.dart';
import '../../controller/auth_controllers/set_password_controller.dart';
import '../../widgets/snake_bar_message.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _passwordTEController = TextEditingController();
  final _confirmTEController = TextEditingController();
  final setPasswordController = Get.find<SetPasswordController>();
  final _formKey = GlobalKey<FormState>();

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
                      'Set Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "Maximum length password 8 character with Latter and Number combination",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Enter password';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _passwordTEController,
                      decoration: const InputDecoration(hintText: "Password "),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Confirm password';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _confirmTEController,
                      decoration:
                          const InputDecoration(hintText: "Confirm Password "),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GetBuilder<SetPasswordController>(builder: (setPasswordController){return Visibility(
                      visible: !setPasswordController.setPasswordInProgress,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: onTapConfirmButton,
                          child: const Text('Confirm')),
                    );}),

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
                              ..onTap = onTapSignInButton,
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

  onTapSignInButton() {
    Get.offAllNamed(Routes.signInScreenRoutes);
  }

  onTapConfirmButton()async {
    if (_formKey.currentState!.validate() &&
        _passwordTEController.text == _confirmTEController.text) {
    bool isSuccess=await setPasswordController.setPassword(widget.otp, widget.email, _confirmTEController.text);
    if(isSuccess){
      Get.offAllNamed(Routes.signInScreenRoutes);
      showSnakeBarMessage(context, "Reset Password Successfully!!!");

    }
    else{
      showSnakeBarMessage(context, setPasswordController.errorMessage,true);
    }
    } else {
      if (mounted) {
        showSnakeBarMessage(
            context, 'Write Same Password in both Field  !! Try again', true);
      }
    }
  }



  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmTEController.dispose();

    super.dispose();
  }
}
