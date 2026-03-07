import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import 'cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => Text(
              'My Cart (${controller.cartService.itemCount})',
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: controller.clearCart,
            child: const Text('Clear All',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.cartService.cartItems.isEmpty) {
          return _buildEmptyCart();
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: controller.cartService.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartService.cartItems[index];
                  return _buildCartItem(item, index);
                },
              ),
            ),
            _buildOrderSummary(),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Text('🛒', style: TextStyle(fontSize: 60)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add delicious items to get started!',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Browse Menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(item, int index) {
    return Dismissible(
      key: Key(item.food.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.remove(item.food.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.red, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Food image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: item.food.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (ctx, url) =>
                    Container(width: 80, height: 80, color: Colors.grey[200]),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.food.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.food.price.toStringAsFixed(2)} each',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity controls
                      Row(
                        children: [
                          _qBtn(Icons.remove,
                              () => controller.decrement(item.food.id)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Obx(() => Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                )),
                          ),
                          _qBtn(Icons.add,
                              () => controller.increment(item.food.id),
                              filled: true),
                        ],
                      ),
                      Obx(() => Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() => Column(
            children: [
              _priceRow('Subtotal', '\$${controller.cartService.subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              _priceRow('Delivery Fee', '\$${controller.cartService.deliveryFee.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              _priceRow('Taxes (8%)', '\$${controller.cartService.taxes.toStringAsFixed(2)}'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(),
              ),
              _priceRow(
                'Total',
                '\$${controller.cartService.total.toStringAsFixed(2)}',
                isBold: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.payment_rounded),
                      const SizedBox(width: 10),
                      Text(
                        'Proceed to Pay  •  \$${controller.cartService.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isBold ? AppColors.primary : AppColors.textPrimary,
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _qBtn(IconData icon, VoidCallback onTap, {bool filled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: filled ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(icon, size: 16, color: filled ? Colors.white : AppColors.textPrimary),
      ),
    );
  }
}
