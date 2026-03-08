import 'package:flutter/material.dart';
import 'package:foodgo/modules/forget_password/forget_password_controller.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Back button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)]),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 28),

              // Lock icon
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 36),
              ),
              const SizedBox(height: 24),

              const Text('Forgot Password? 🔑',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('Enter your email address and we will send you a password reset link.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: 36),

              // Email field
              const Text('Email',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)]),
                child: TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.textLight, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
                ),
              ),
              const SizedBox(height: 32),

              // Error message
              Obx(() => controller.errorMessage.value.isNotEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200)),
                    child: Row(children: [
                      Icon(Icons.error_outline, color: Colors.red.shade600, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(controller.errorMessage.value,
                        style: TextStyle(color: Colors.red.shade700, fontSize: 13))),
                    ]),
                  )
                : const SizedBox.shrink()),

              // Success message
              Obx(() => controller.successMessage.value.isNotEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200)),
                    child: Row(children: [
                      Icon(Icons.check_circle_outline, color: Colors.green.shade600, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(controller.successMessage.value,
                        style: TextStyle(color: Colors.green.shade700, fontSize: 13))),
                    ]),
                  )
                : const SizedBox.shrink()),

              // Send button
              Obx(() => SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.sendResetEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0),
                  child: controller.isLoading.value
                    ? const SizedBox(width: 24, height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Send Reset Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              )),
              const SizedBox(height: 24),

              // Back to login
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Remember your password? ',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      children: [
                        TextSpan(text: 'Login',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}