import 'package:foodgo/modules/food_model.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../services/cart_service.dart';
import '../favorites/favorites_controller.dart';
import '../home/home_controller.dart';

class ProductDetailController extends GetxController {
  final CartService cartService = Get.find<CartService>();
  FavoritesController get _favCtrl => Get.find<FavoritesController>();
  HomeController get _homeCtrl => Get.find<HomeController>();

  late final FoodModel food;
  final RxInt quantity = 1.obs;
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

  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }
  void setSpicyLevel(double val) => spicyLevel.value = val;

  void toggleFavorite() => _favCtrl.toggleFavorite(food.id);

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

    // ✅ HomeController ki qty bhi reset — FoodCard aur Favorites dono 0 ho jayenge
    _homeCtrl.resetLocalQty(food.id);
    // ✅ Detail screen ki qty bhi 1 pe reset
    quantity.value = 1;

    Get.offNamed(Routes.CART); // ✅ Product detail stack mein nahi rahega
  }
}