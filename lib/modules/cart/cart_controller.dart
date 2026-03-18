import 'package:get/get.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';
import '../../routes/app_pages.dart';

class CartController extends GetxController {
  final CartService cartService = Get.find<CartService>();
  final OrderService orderService = Get.find<OrderService>();

  void increment(String foodId) => cartService.incrementQuantity(foodId);
  void decrement(String foodId) => cartService.decrementQuantity(foodId);
  void remove(String foodId)    => cartService.removeFromCart(foodId);
  void clearCart()              => cartService.clearCart();

  void proceedToPayment() {
    // ✅ Sirf navigate karo — cart clear mat karo abhi
    // Order aur cart clear payment complete hone ke baad hoga
    Get.toNamed(Routes.PAYMENT);
  }

  // ✅ Yeh method payment screen se call karo jab payment done ho
  void onPaymentSuccess() {
    final order = OrderModel(
      id: orderService.generateOrderId(),
      date: orderService.formatDate(DateTime.now()),
      itemCount: cartService.itemCount,
      total: cartService.total,
      status: 'Delivered',
      items: cartService.cartItems.map((item) => {
        'name': item.food.name,
        'qty': item.quantity,
        'price': item.food.price,
      }).toList(),
    );

    orderService.saveOrder(order);
    cartService.clearCart(); // ✅ Ab clear karo
  }
}