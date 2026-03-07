import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'services/cart_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  Get.put<CartService>(CartService(), permanent: true);
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
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}