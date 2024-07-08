import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/utility/app_constant.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/snake_bar_message.dart';

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
  bool _registrationInProgress = false;

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
                    Visibility(
                      visible: !_registrationInProgress,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                          onPressed: () async {
                            onTapSignInButton();
                          },
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
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => SignInScreen()));
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
      await _registerUser();
    }
  }

  _registerUser() async {
    _registrationInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestInput = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileNoTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": "",
    };
    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.registration, body: requestInput);
    _registrationInProgress = false;
    if (response.isSuccess) {
      if (mounted) {
        showSnakeBarMessage(context, "Registration Successful");
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const SignInScreen()),
          (route) => false);
      _clearTextField();
    } else {
      if (mounted) {
        showSnakeBarMessage(context,
            response.errorMessage ?? 'Registration Failed Try Again!!', true);
      }
    }
  }

  void _clearTextField() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileNoTEController.clear();
    _passwordTEController.clear();
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
