import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/routes.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snake_bar_message.dart';

import '../../controller/auth_controllers/email_verification_controller.dart';
import '../../utility/app_constant.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _emailTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final emailVerificationController=Get.find<EmailVerificationController>();

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
                      "Your Email Address",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "A 6 digit verification pin will send to your email address",
                      style: Theme.of(context).textTheme.titleSmall,
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
                    const SizedBox(
                      height: 8,
                    ),
                    GetBuilder<EmailVerificationController>(builder: (emailVerificationController){return Visibility(
                      visible: !emailVerificationController.verifyEmailInProgress,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: _onTapConfirmButton,
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    ); }),

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
                              ..onTap = _onTapSignInButton,
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

  _onTapSignInButton() {
   Get.offAllNamed(Routes.signInScreenRoutes);
  }

  _onTapConfirmButton() async{
    if (_formKey.currentState!.validate()) {
     bool isSuccess = await  emailVerificationController.emailValidate(_emailTEController.text.trim());
     if(isSuccess){
       Get.offAllNamed(Routes.otpVerificationScreenRoutes(_emailTEController.text.trim()));
     }
     else{
       showSnakeBarMessage(context,emailVerificationController.errorMessage,true);

     }
    }
  }



  @override
  void dispose() {
    _emailTEController.dispose();

    super.dispose();
  }
}
