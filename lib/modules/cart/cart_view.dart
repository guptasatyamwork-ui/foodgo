import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../routes/app_pages.dart';
import 'cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // ✅ Back karo to home screen pe jao — stack saaf
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.offAllNamed(Routes.HOME),
        ),
        title: Obx(() => Text('Cart (${controller.cartService.itemCount})')),
        actions: [
          TextButton(
            onPressed: controller.clearCart,
            child: const Text('Clear All',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.cartService.cartItems.isEmpty) return _emptyCart();
        return Column(children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: controller.cartService.cartItems.length,
              itemBuilder: (_, i) => _cartItem(controller.cartService.cartItems[i]),
            ),
          ),
          _summary(),
        ]);
      }),
    );
  }

  Widget _emptyCart() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), shape: BoxShape.circle),
          child: const Text('🛒', style: TextStyle(fontSize: 52)),
        ),
        const SizedBox(height: 18),
        const Text('Your cart is empty',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Add some delicious food!',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 22),
        ElevatedButton(
          // ✅ Browse Menu bhi seedha home pe
          onPressed: () => Get.offAllNamed(Routes.HOME),
          style: ElevatedButton.styleFrom(minimumSize: const Size(160, 46)),
          child: const Text('Browse Menu'),
        ),
      ]),
    );
  }

  Widget _cartItem(item) {
    return Dismissible(
      key: Key(item.food.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.remove(item.food.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            color: Colors.red.shade50, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 26),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.food.imageUrl,
              width: 76, height: 76, fit: BoxFit.cover,
              placeholder: (_, __) => Container(width: 76, height: 76, color: const Color(0xFFF3F4F6)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.food.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Text('\$${item.food.price.toStringAsFixed(2)} each',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              Row(children: [
                _qBtn(Icons.remove, () => controller.decrement(item.food.id)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('${item.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textPrimary)),
                ),
                _qBtn(Icons.add, () => controller.increment(item.food.id), filled: true),
                const Spacer(),
                Text('\$${item.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primary)),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _summary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: Obx(() => Column(mainAxisSize: MainAxisSize.min, children: [
        _row('Subtotal',   '\$${controller.cartService.subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        _row('Delivery',   '\$${controller.cartService.deliveryFee.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        _row('Taxes (8%)', '\$${controller.cartService.taxes.toStringAsFixed(2)}'),
        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
        _row('Total', '\$${controller.cartService.total.toStringAsFixed(2)}', bold: true),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: controller.proceedToPayment,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.payment_rounded, size: 20),
            const SizedBox(width: 10),
            Text('Proceed to Pay  •  \$${controller.cartService.total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ]),
        ),
      ])),
    );
  }

  Widget _row(String l, String v, {bool bold = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: TextStyle(
          color: bold ? AppColors.textPrimary : AppColors.textSecondary,
          fontSize: bold ? 16 : 13,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
      Text(v, style: TextStyle(
          color: bold ? AppColors.primary : AppColors.textPrimary,
          fontSize: bold ? 18 : 13,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
    ],
  );

  Widget _qBtn(IconData icon, VoidCallback onTap, {bool filled = false}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: filled ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: filled ? null : Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Icon(icon, size: 15, color: filled ? Colors.white : AppColors.textPrimary),
        ),
      );
}