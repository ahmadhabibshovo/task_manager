import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';

import '../../../data/model/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
import '../../utility/app_constant.dart';
import '../../widgets/snake_bar_message.dart';
import 'pin_verification_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _emailTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _verifyEmailInProgress = false;

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
                    Visibility(
                      visible: _verifyEmailInProgress == false,
                      replacement: CenteredProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: _onTapConfirmButton,
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    ),
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
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const SignInScreen()));
  }

  _onTapConfirmButton() {
    if (_formKey.currentState!.validate()) {
      _emailValidate();
    }
  }

  _emailValidate() async {
    _verifyEmailInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(
        Urls.recoverVerifyEmail(_emailTEController.text.trim()));
    if (response.isSuccess) {
      if (mounted) {
        showSnakeBarMessage(context, 'Otp Send');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => PinVerificationScreen(
                      email: _emailTEController.text.trim(),
                    )));
      }
    } else {
      if (mounted) {
        showSnakeBarMessage(context, 'Email not Valid !! Try again', true);
      }
    }
    _verifyEmailInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();

    super.dispose();
  }
}
