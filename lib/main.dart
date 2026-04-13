import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodgo/core/sevice/auth_service.dart';
import 'package:foodgo/modules/favorites/favorites_controller.dart';
import 'package:foodgo/core/sevice/order_service.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'core/sevice/cart_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env"); // ← YEH LINE ADD KARO

  // Firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Services register
  final authService = AuthService();
  await authService.init();
  Get.put<AuthService>(authService, permanent: true);
  Get.put<CartService>(CartService(), permanent: true);
  Get.put<OrderService>(OrderService(), permanent: true);
  Get.put<FavoritesController>(FavoritesController(), permanent: true);

  runApp(const FoodgoApp());
}

class FoodgoApp extends StatelessWidget {
  const FoodgoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Foodgo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}