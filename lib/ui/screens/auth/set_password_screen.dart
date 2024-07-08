import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';

import '../../../data/model/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
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
  bool _resetPasswordInProgress = false;
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
                    Visibility(
                      visible: _resetPasswordInProgress == false,
                      replacement: CenteredProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: onTapConfirmButton,
                          child: const Text('Confirm')),
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
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const SignInScreen()));
  }

  onTapConfirmButton() {
    if (_formKey.currentState!.validate() &&
        _passwordTEController.text == _confirmTEController.text) {
      _resetPassword();
    } else {
      if (mounted) {
        showSnakeBarMessage(
            context, 'Write Same Password in both Field  !! Try again', true);
      }
    }
  }

  _resetPassword() async {
    _resetPasswordInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestBody = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _confirmTEController.text
    };

    NetworkResponse response = await NetworkCaller.postRequest(
        Urls.recoverResetPassWord,
        body: requestBody);
    if (response.isSuccess) {
      if (mounted) {
        showSnakeBarMessage(context, 'Password reset');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => SignInScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        showSnakeBarMessage(context, 'Something is Wrong  !! Try again', true);
      }
    }
    _resetPasswordInProgress = false;
    setState(() {});
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmTEController.dispose();

    super.dispose();
  }
}
