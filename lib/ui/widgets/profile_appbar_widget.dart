import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes.dart';
import '../controller/auth_controllers/auth_controller.dart';
import '../utility/app_colors.dart';

AppBar profileAppBar(context, [bool fromUpdateProfile = false]) {
  return AppBar(
    title: GestureDetector(
      onTap: () {
        if (fromUpdateProfile) {
          return;
        }
        Get.toNamed(Routes.updateProfileScreen);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.fullName,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            AuthController.userData!.email!,
            style: const TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
    actions: [
      IconButton(
          onPressed: () {
            Get.offAllNamed(Routes.signInScreenRoutes);
            AuthController.clearALlData();
          },
          icon: const Icon(Icons.logout))
    ],
    backgroundColor: AppColors.themeColor,
    leading: GestureDetector(
      onTap: () {
        Get.toNamed(Routes.updateProfileScreen);
      },
    ),
  );
}
