import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../routes/app_pages.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _goHome();
  }

  Future<void> _goHome() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE23744),
              Color(0xFFB71C1C),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text('🍔', style: TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: 24),
            // App name
            const Text(
              'Foodgo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Order food, delivered fast',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}