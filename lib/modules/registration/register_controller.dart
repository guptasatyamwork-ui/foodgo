import 'package:flutter/material.dart';
import 'package:foodgo/core/sevice/auth_service.dart';
import 'package:foodgo/routes/app_pages.dart';
import 'package:get/get.dart';


class RegisterController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final nameController            = TextEditingController();
  final emailController           = TextEditingController();
  final passwordController        = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading       = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirm  = true.obs;
  final errorMessage    = ''.obs;

  void togglePassword() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirm()  => obscureConfirm.value  = !obscureConfirm.value;

  Future<void> register() async {
    final name     = nameController.text.trim();
    final email    = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm  = confirmPasswordController.text.trim();

    // Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      errorMessage.value = 'Saare fields bharo.';
      return;
    }
    if (!GetUtils.isEmail(email)) {
      errorMessage.value = 'Sahi email format likho.';
      return;
    }
    if (password.length < 6) {
      errorMessage.value = 'Password kam se kam 6 characters ka hona chahiye.';
      return;
    }
    if (password != confirm) {
      errorMessage.value = 'Password match nahi kar raha.';
      return;
    }

    isLoading.value    = true;
    errorMessage.value = '';

    final error = await _authService.register(
      name: name, email: email, password: password);

    isLoading.value = false;

    if (error == null) {
      // Success — Home pe jao
      Get.offAllNamed(Routes.HOME);
    } else {
      errorMessage.value = error;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}