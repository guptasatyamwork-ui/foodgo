import 'package:get/get.dart';
import '../modules/splash/splash_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/product_detail/product_detail_view.dart';
import '../modules/product_detail/product_detail_binding.dart';
import '../modules/cart/cart_view.dart';
import '../modules/cart/cart_binding.dart';
import '../modules/payment/payment_view.dart';
import '../modules/payment/payment_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/profile/profile_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.PRODUCT_DETAIL,
      page: () => ProductDetailView(),
      binding: ProductDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.CART,
      page: () => CartView(),
      binding: CartBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => PaymentView(),
      binding: PaymentBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
