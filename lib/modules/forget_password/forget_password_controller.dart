import 'package:flutter/material.dart';
import 'package:foodgo/core/sevice/auth_service.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController  = TextEditingController();
  final isLoading        = false.obs;
  final errorMessage     = ''.obs;
  final successMessage   = ''.obs;

  Future<void> sendResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      errorMessage.value   = 'Email address daalo.';
      successMessage.value = '';
      return;
    }
    if (!GetUtils.isEmail(email)) {
      errorMessage.value   = 'Sahi email format likho.';
      successMessage.value = '';
      return;
    }

    isLoading.value      = true;
    errorMessage.value   = '';
    successMessage.value = '';

    final error = await _authService.resetPassword(email: email);

    isLoading.value = false;

    if (error == null) {
      // ✅ Email bhej diya
      successMessage.value = 'Reset link "$email" pe bhej diya gaya hai. Email check karo!';
      emailController.clear();
    } else {
      errorMessage.value = error;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}