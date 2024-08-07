import 'package:get/get.dart';
import 'package:task_manager/ui/controller/add_new_task_controller.dart';
import 'package:task_manager/ui/controller/auth_controllers/sign_up_controller.dart';
import 'package:task_manager/ui/controller/update_profile_controller.dart';
import 'package:task_manager/ui/controller/cancelled_task_controller.dart';
import 'package:task_manager/ui/controller/completed_task_controller.dart';
import 'package:task_manager/ui/controller/delete_task_controller.dart';

import 'package:task_manager/ui/controller/in_progress_task_controller.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';

import 'package:task_manager/ui/controller/auth_controllers/sign_in_controller.dart';
import 'package:task_manager/ui/controller/task_summery_controller.dart';
import 'package:task_manager/ui/controller/task_update_controller.dart';

import 'ui/controller/auth_controllers/email_verification_controller.dart';
import 'ui/controller/auth_controllers/otp_verification_controller.dart';
import 'ui/controller/auth_controllers/set_password_controller.dart';


class ControllerBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> SignInController(),fenix: true);
    Get.lazyPut(()=> SignUpController(),fenix: true);
    Get.lazyPut(()=> EmailVerificationController(),fenix: true);
    Get.lazyPut(()=> OTPVerificationController(),fenix: true);
    Get.lazyPut(()=> SetPasswordController(),fenix: true);
    Get.lazyPut(()=>NewTaskController(),fenix: true);
    Get.lazyPut(()=>CompletedTaskController(),fenix: true);
    Get.lazyPut(()=>CancelledTaskController(),fenix: true);
    Get.lazyPut(()=>InProgressTaskController(),fenix: true);
    Get.lazyPut(()=>AddNewTaskController(),fenix: true);
    Get.lazyPut(()=>TaskSummeryController(),fenix: true);
    Get.lazyPut(()=>UpdateProfileController(),fenix: true);
    Get.create(()=>TaskUpdateController());
    Get.create(()=>DeleteTaskController(),);
  }
}