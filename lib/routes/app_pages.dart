import 'package:foodgo/modules/about/about_binding.dart';
import 'package:foodgo/modules/edite_profile/edit_profile_binding.dart';
import 'package:foodgo/modules/edite_profile/edite_profile_view.dart';
import 'package:foodgo/modules/favorites/favorites_binding.dart';
import 'package:foodgo/modules/favorites/favorites_view.dart';
import 'package:foodgo/modules/forget_password/forget_password_binding.dart';
import 'package:foodgo/modules/forget_password/forget_password_view.dart';
import 'package:foodgo/modules/home/visual_saerch_result_view.dart';
import 'package:foodgo/modules/login/login_binding.dart';
import 'package:foodgo/modules/login/login_view.dart';
import 'package:foodgo/modules/about/about_view.dart';
import 'package:foodgo/modules/profile/view/help_support_view.dart';
import 'package:foodgo/modules/registration/register_view.dart';
import 'package:foodgo/modules/registration/registration_binding.dart';
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
import '../modules/profile/view/profile_view.dart';
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
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
  name: Routes.HELP_SUPPORT,
  page: () => const HelpSupportView(),
),
GetPage(
  name: Routes.ABOUT,
  page: () => const AboutView(),
  binding: AboutBinding(),  
),
GetPage(
  name: Routes.FAVORITES,
  page: () => const FavoritesView(),
  binding: FavoritesBinding(),
),
GetPage(
  name: Routes.VISUAL_SEARCH_RESULT,
  page: () => const VisualSearchResultView(),
),
  ];
}
