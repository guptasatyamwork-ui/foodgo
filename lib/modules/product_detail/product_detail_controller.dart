// lib/modules/product_detail/product_detail_controller.dart

import 'package:foodgo/core/sevice/api_sevice.dart';
import 'package:foodgo/core/sevice/cart_service.dart';
import 'package:foodgo/core/sevice/food_service.dart';
import 'package:foodgo/modules/food_model.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../favorites/favorites_controller.dart';
import '../home/home_controller.dart';

class ProductDetailController extends GetxController {
  final CartService cartService = Get.find<CartService>();
  FavoritesController get _favCtrl => Get.find<FavoritesController>();
  HomeController get _homeCtrl     => Get.find<HomeController>();

  late final FoodModel food;
  final RxInt    quantity   = 1.obs;
  final RxDouble spicyLevel = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      food = args['food'] as FoodModel;
      final preQty = args['qty'] as int? ?? 1;
      quantity.value = preQty;
    } else {
      food = args as FoodModel;
      quantity.value = 1;
    }
  }

  void increment()               => quantity.value++;
  void decrement()               { if (quantity.value > 1) quantity.value--; }
  void setSpicyLevel(double val) => spicyLevel.value = val;
  void toggleFavorite()          => _favCtrl.toggleFavorite(food.id);

  double get totalPrice => food.price * quantity.value;

  void addToCart() {
    if (cartService.isInCart(food.id)) {
      for (int i = 0; i < quantity.value; i++) {
        cartService.incrementQuantity(food.id);
      }
    } else {
      cartService.addToCart(food, spicyLevel: spicyLevel.value.round());
      for (int i = 1; i < quantity.value; i++) {
        cartService.incrementQuantity(food.id);
      }
    }
    _homeCtrl.resetLocalQty(food.id);
    quantity.value = 1;
    Get.offNamed(Routes.CART);
  }

  /// Related products — same category, API first, fallback
  Future<List<FoodModel>> getRelatedProducts() async {
    try {
      final all  = await ApiService.getFoodsByCategory(food.category);
      final same = all.where((f) => f.id != food.id).toList();
      return same;
    } catch (_) {
      return FoodService.getFoodsByCategory(food.category)
          .where((f) => f.id != food.id)
          .toList();
    }
  }
}