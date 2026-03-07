import 'package:get/get.dart';
import '../{core,modules,widgets,routes,models,services}/models/food_model.dart';

class CartService extends GetxService {
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => subtotal > 0 ? 2.99 : 0.0;
  double get taxes => subtotal * 0.08;
  double get total => subtotal + deliveryFee + taxes;

  void addToCart(FoodModel food, {int spicyLevel = 1}) {
    final existingIndex = cartItems.indexWhere((item) => item.food.id == food.id);
    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(food: food, quantity: 1, spicyLevel: spicyLevel));
    }
    Get.snackbar(
      'Added to Cart',
      '${food.name} added successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void removeFromCart(String foodId) {
    cartItems.removeWhere((item) => item.food.id == foodId);
  }

  void incrementQuantity(String foodId) {
    final index = cartItems.indexWhere((item) => item.food.id == foodId);
    if (index >= 0) {
      cartItems[index].quantity++;
      cartItems.refresh();
    }
  }

  void decrementQuantity(String foodId) {
    final index = cartItems.indexWhere((item) => item.food.id == foodId);
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        cartItems.removeAt(index);
      }
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  bool isInCart(String foodId) {
    return cartItems.any((item) => item.food.id == foodId);
  }
}
