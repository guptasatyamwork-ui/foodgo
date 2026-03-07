import 'package:get/get.dart';
import '../../services/cart_service.dart';
import '../../routes/app_pages.dart';

class CartController extends GetxController {
  final CartService cartService = Get.find<CartService>();

  void increment(String foodId) => cartService.incrementQuantity(foodId);
  void decrement(String foodId) => cartService.decrementQuantity(foodId);
  void remove(String foodId) => cartService.removeFromCart(foodId);

  void proceedToPayment() {
    Get.toNamed(Routes.PAYMENT);
  }

  void clearCart() {
    cartService.clearCart();
  }
}
