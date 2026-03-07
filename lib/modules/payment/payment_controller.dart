import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/cart_service.dart';

class PaymentController extends GetxController {
  final CartService cartService = Get.find<CartService>();

  final RxInt selectedPaymentIndex = 0.obs;
  final RxBool isProcessing = false.obs;

  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'Credit Card', 'icon': Icons.credit_card_rounded, 'detail': '**** **** **** 4242'},
    {'name': 'PayPal', 'icon': Icons.account_balance_wallet_rounded, 'detail': 'user@email.com'},
    {'name': 'Apple Pay', 'icon': Icons.apple_rounded, 'detail': 'Touch to pay'},
    {'name': 'Google Pay', 'icon': Icons.g_mobiledata_rounded, 'detail': 'Tap to pay'},
    {'name': 'Cash on Delivery', 'icon': Icons.money_rounded, 'detail': 'Pay at door'},
  ];

  void selectPayment(int index) {
    selectedPaymentIndex.value = index;
  }

  Future<void> processPayment() async {
    isProcessing.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isProcessing.value = false;
    cartService.clearCart();
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🎉', style: TextStyle(fontSize: 50)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Order Placed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your order has been placed successfully.\nEstimated delivery: 25–35 min 🚀',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE23744),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
