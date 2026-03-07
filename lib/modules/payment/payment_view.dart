import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import 'payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery address
            _buildSection(
              title: '📍 Delivery Address',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.home_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Home',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text('123 Main Street, New York, NY 10001',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text('Change',
                            style: TextStyle(color: AppColors.primary, fontSize: 12))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Payment methods
            _buildSection(
              title: '💳 Payment Method',
              child: Column(
                children: controller.paymentMethods.asMap().entries.map((entry) {
                  return Obx(() => _buildPaymentOption(
                        entry.key,
                        entry.value['name'],
                        entry.value['icon'],
                        entry.value['detail'],
                        controller.selectedPaymentIndex.value == entry.key,
                      ));
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Order Summary
            _buildSection(
              title: '📋 Order Summary',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ...controller.cartService.cartItems.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.food.name} x${item.quantity}',
                                  style: const TextStyle(
                                      fontSize: 13, color: AppColors.textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )),
                    const Divider(),
                    Obx(() => Column(
                          children: [
                            _summaryRow('Subtotal',
                                '\$${controller.cartService.subtotal.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            _summaryRow('Delivery',
                                '\$${controller.cartService.deliveryFee.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            _summaryRow('Taxes (8%)',
                                '\$${controller.cartService.taxes.toStringAsFixed(2)}'),
                            const Divider(height: 24),
                            _summaryRow(
                              'Total',
                              '\$${controller.cartService.total.toStringAsFixed(2)}',
                              isBold: true,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Pay button
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isProcessing.value ? null : controller.processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isProcessing.value
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              ),
                              SizedBox(width: 12),
                              Text('Processing...',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ],
                          )
                        : Obx(() => Text(
                              'Pay Now  •  \$${controller.cartService.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            )),
                  ),
                )),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_rounded, color: AppColors.textLight, size: 14),
                  const SizedBox(width: 6),
                  const Text('Secured by 256-bit SSL encryption',
                      style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 14),
        child,
      ],
    );
  }

  Widget _buildPaymentOption(
      int index, String name, IconData icon, String detail, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.selectPayment(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                  Text(detail,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[400]!,
                    width: 2),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: isBold ? 16 : 13,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w400)),
        Text(value,
            style: TextStyle(
                color: isBold ? AppColors.primary : AppColors.textPrimary,
                fontSize: isBold ? 18 : 13,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600)),
      ],
    );
  }
}
