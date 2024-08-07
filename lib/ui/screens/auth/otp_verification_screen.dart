import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snake_bar_message.dart';

import '../../../routes.dart';
import '../../controller/auth_controllers/otp_verification_controller.dart';



class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _pinTEController = TextEditingController();
 final otpVerificationController = Get.find<OTPVerificationController>();

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
                 GetBuilder<OTPVerificationController>(builder: (otpVerificationController){
                   return  Visibility(
                     visible: !otpVerificationController.verifyOTPInProgress,
                     replacement: const CenteredProgressIndicator(),
                     child: ElevatedButton(
                         onPressed: onTapConfirmButton,
                         child: const Text('Verify')),
                   );
                 }),
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
      autoDisposeControllers: false,
    );
  }

  onTapSignInButton() {
   Get.offAllNamed(Routes.signInScreenRoutes);
  }

  onTapConfirmButton() async{
    if (_pinTEController.text.trim().length == 6) {
      bool isSuccess = await otpVerificationController.otpValidate(_pinTEController.text.trim(), widget.email);
      if(isSuccess){
        Get.offAllNamed(Routes.setPasswordScreenRoutes(_pinTEController.text.trim()));
      }
      else{
        showSnakeBarMessage(context, otpVerificationController.errorMessage,true);
      }
    }
  }


  @override
  void dispose() {
    _pinTEController.dispose();

    super.dispose();
  }
}
