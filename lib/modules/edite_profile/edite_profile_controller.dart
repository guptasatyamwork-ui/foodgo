import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  final RxBool isSaving = false.obs;

  static const String _keyName    = 'profile_name';
  static const String _keyPhone   = 'profile_phone';
  static const String _keyAddress = 'profile_address';

  @override
  void onInit() {
    super.onInit();
    // Get current values passed from ProfileController
    final args = Get.arguments as Map<String, String>? ?? {};
    nameController    = TextEditingController(text: args['name']    ?? '');
    phoneController   = TextEditingController(text: args['phone']   ?? '');
    addressController = TextEditingController(text: args['address'] ?? '');
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> saveProfile() async {
    // Basic validation
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    if (phoneController.text.trim().isNotEmpty &&
        phoneController.text.trim().length < 10) {
      Get.snackbar(
        'Invalid',
        'Please enter a valid mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    isSaving.value = true;

    try {
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyName,    nameController.text.trim());
      await prefs.setString(_keyPhone,   phoneController.text.trim());
      await prefs.setString(_keyAddress, addressController.text.trim());

      // Return updated values back to ProfileController
      Get.back(result: {
        'name':    nameController.text.trim(),
        'phone':   phoneController.text.trim(),
        'address': addressController.text.trim(),
      });

      Get.snackbar(
        '✅ Profile Updated',
        'Your profile has been saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not save profile. Try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }
}