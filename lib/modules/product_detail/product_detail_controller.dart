import 'package:get/get.dart';
import '../../{core,modules,widgets,routes,models,services}/models/food_model.dart';
import '../../services/cart_service.dart';

class ProductDetailController extends GetxController {
  final CartService cartService = Get.find<CartService>();

  late final FoodModel food;
  final RxInt quantity = 1.obs;
  final RxDouble spicyLevel = 1.0.obs;
  final RxBool isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    food = Get.arguments as FoodModel;
  }

  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void setSpicyLevel(double val) {
    spicyLevel.value = val;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  double get totalPrice => food.price * quantity.value;

  void addToCart() {
    for (int i = 0; i < quantity.value; i++) {
      if (i == 0) {
        cartService.addToCart(food, spicyLevel: spicyLevel.value.round());
      } else {
        cartService.incrementQuantity(food.id);
      }
    }
    Get.back();
  }
}
