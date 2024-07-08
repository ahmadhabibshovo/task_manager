import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/model/login_response.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/email_verifiction_screen.dart';
import 'package:task_manager/ui/screens/auth/sign_up_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
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
  bool _isSignInProgress = false;

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
                    Visibility(
                      visible: !_isSignInProgress,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                          onPressed: onTapNextButton,
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    ),
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
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const SignUpScreen()));
  }

  onTapForgetPasswordButton() {
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => const EmailVerificationScreen()));
  }

  onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    _isSignInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestData = {
      'email': _emailTEController.text.trim(),
      'password': _passwordTEController.text
    };
    final NetworkResponse networkResponse =
        await NetworkCaller.postRequest(Urls.login, body: requestData);
    _isSignInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (networkResponse.isSuccess) {
      showSnakeBarMessage(
        context,
        'Login Successful',
      );
      LoginResponse loginResponse =
          LoginResponse.fromJson(networkResponse.responseData);
      await AuthController.saveUserAccessToken(loginResponse.token!);
      await AuthController.saveUserData(loginResponse.userModel!);
      print(loginResponse.userModel);
      await AuthController.saveLoginData(
          _emailTEController.text.trim(), _passwordTEController.text);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (ctx) => const MainBottomNavScreen()));
    } else {
      showSnakeBarMessage(
          context,
          networkResponse.errorMessage ??
              'Email or Password is not Correct try again',
          true);
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
