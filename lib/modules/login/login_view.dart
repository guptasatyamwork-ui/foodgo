import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // Logo
              Center(
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(24)),
                  child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 40),
                ),
              ),
              const SizedBox(height: 32),
              const Text('Welcome Back! 👋',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('Login to continue ordering your favorite food',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 40),

              // Email field
              _label('Email'),
              const SizedBox(height: 8),
              _textField(
                controller: controller.emailController,
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password field
              _label('Password'),
              const SizedBox(height: 8),
              Obx(() => _textField(
                controller: controller.passwordController,
                hint: 'Enter your password',
                icon: Icons.lock_outline,
                isPassword: true,
                obscure: controller.obscurePassword.value,
                onToggleObscure: controller.togglePassword,
              )),
              const SizedBox(height: 12),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: controller.goToForgotPassword,
                  child: const Text('Forgot Password?',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
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

              // Login button
              Obx(() => SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0),
                  child: controller.isLoading.value
                    ? const SizedBox(width: 24, height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              )),
              const SizedBox(height: 24),

              // Register link
              Center(
                child: GestureDetector(
                  onTap: controller.goToRegister,
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      children: [
                        TextSpan(text: 'Sign Up',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary));

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)]),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? obscure : false,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.textLight, size: 20),
          suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textLight, size: 20),
                onPressed: onToggleObscure)
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      ),
    );
  }
}