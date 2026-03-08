import 'package:flutter/material.dart';
import 'package:foodgo/core/sevice/auth_service.dart';
import 'package:foodgo/routes/app_pages.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim  = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animCtrl, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));
    _scaleAnim = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _animCtrl, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)));

    _animCtrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final authService = Get.find<AuthService>();

    // Firebase current user check karo
    if (authService.isAuthenticated) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Center(
          child: AnimatedBuilder(
            animation: _animCtrl,
            builder: (_, __) => FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(32)),
                    child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 52)),
                  const SizedBox(height: 20),
                  const Text('Foodgo',
                    style: TextStyle(color: Colors.white, fontSize: 36,
                      fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  const Text('Order your favorite food',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}