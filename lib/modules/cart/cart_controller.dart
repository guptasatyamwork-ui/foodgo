import 'package:get/get.dart';
import '../../services/cart_service.dart';
import '../../routes/app_pages.dart';

class CartController extends GetxController {
  final CartService cartService = Get.find<CartService>();

  // ✅ Match CartService method names exactly
  void increment(String foodId) => cartService.incrementQuantity(foodId);
  void decrement(String foodId) => cartService.decrementQuantity(foodId);
  void remove(String foodId)    => cartService.removeFromCart(foodId);
  void clearCart()              => cartService.clearCart();

  void proceedToPayment() => Get.toNamed(Routes.PAYMENT);
}