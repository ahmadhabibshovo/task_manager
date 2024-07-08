import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/screens/auth/set_password_screen.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';

import '../../../data/model/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
import '../../widgets/snake_bar_message.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final _pinTEController = TextEditingController();
  bool _otpVerifyInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    "Pin Verification",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "A 6 digit verification pin will send to your email address",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  _buildPinCodeTextField(),
                  const SizedBox(
                    height: 8,
                  ),
                  Visibility(
                    visible: _otpVerifyInProgress == false,
                    replacement: const CenteredProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: onTapConfirmButton,
                        child: const Text('Verify')),
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
    );
  }

  PinCodeTextField _buildPinCodeTextField() {
    return PinCodeTextField(
      validator: (value) {
        if (value == null || value.trim().length < 6) {
          return "Enter Otp";
        } else {
          return '';
        }
      },
      appContext: context,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        selectedColor: AppColors.themeColor,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      keyboardType: TextInputType.number,
      enableActiveFill: true,
      controller: _pinTEController,
    );
  }

  onTapSignInButton() {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const SignInScreen()));
  }

  onTapConfirmButton() {
    if (_pinTEController.text.trim().length == 6) {
      _otpValidate();
    }
  }

  _otpValidate() async {
    _otpVerifyInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(
        Urls.recoverVerifyOtp(_pinTEController.text.trim(), widget.email));
    if (response.isSuccess) {
      if (mounted) {
        showSnakeBarMessage(context, 'Otp Verified');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => SetPasswordScreen(
                      email: widget.email,
                      otp: _pinTEController.text.trim(),
                    )));
      }
    } else {
      if (mounted) {
        showSnakeBarMessage(context, 'Otp not Valid !! Try again', true);
      }
    }
    _otpVerifyInProgress = false;
    setState(() {});
  }

  @override
  void dispose() {
    _pinTEController.dispose();

    super.dispose();
  }
}
