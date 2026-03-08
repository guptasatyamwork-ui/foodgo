import 'package:flutter/material.dart';
import 'package:foodgo/core/sevice/auth_service.dart';
import 'package:foodgo/routes/app_pages.dart';
import 'package:get/get.dart';


class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading       = false.obs;
  final obscurePassword = true.obs;
  final errorMessage    = ''.obs;

  void togglePassword() => obscurePassword.value = !obscurePassword.value;

  Future<void> login() async {
    final email    = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validation
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email aur password dono bharo.';
      return;
    }
    if (!GetUtils.isEmail(email)) {
      errorMessage.value = 'Sahi email format likhो.';
      return;
    }

    isLoading.value    = true;
    errorMessage.value = '';

    final error = await _authService.login(email: email, password: password);

    isLoading.value = false;

    if (error == null) {
      // Success — Home pe jao
      Get.offAllNamed(Routes.HOME);
    } else {
      errorMessage.value = error;
    }
  }

  void goToRegister()       => Get.toNamed(Routes.REGISTER);
  void goToForgotPassword() => Get.toNamed(Routes.FORGOT_PASSWORD);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}