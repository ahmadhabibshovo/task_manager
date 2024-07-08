import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

import '../utility/app_colors.dart';

AppBar profileAppBar(context, [bool fromUpdateProfile = false]) {
  return AppBar(
    title: GestureDetector(
      onTap: () {
        if (fromUpdateProfile) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const UpdateProfileScreen(),
          ),
        );
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
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false);
            AuthController.clearALlData();
          },
          icon: const Icon(Icons.logout))
    ],
    backgroundColor: AppColors.themeColor,
    leading: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const UpdateProfileScreen(),
          ),
        );
      },
      child: CircleAvatar(
        radius: 12,
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: AuthController.userData!.photo == ''
                ? Icon(Icons.person)
                : Image.memory(base64Decode(AuthController.userData!.photo!))),
      ),
    ),
  );
}
