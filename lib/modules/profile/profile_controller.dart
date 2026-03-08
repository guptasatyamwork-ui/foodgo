import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodgo/core/sevice/auth_service.dart';
import 'package:foodgo/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ImagePicker _picker = ImagePicker();

  // Firebase se real user data
  RxString get name  => _authService.userName;
  RxString get email => _authService.userEmail;

  final RxString address = '123 Main Street, New York, NY 10001'.obs;
  final RxString phone   = '+1 (555) 123-4567'.obs;

  // ✅ Local profile photo path
  final RxString localPhotoPath = ''.obs;

  static const String _keyPhoto = 'profile_photo_path';

  final List<Map<String, dynamic>> orderHistory = [
    {'id': '#FG2401', 'date': 'Mar 5, 2026',  'items': 3, 'total': 42.97, 'status': 'Delivered'},
    {'id': '#FG2389', 'date': 'Mar 3, 2026',  'items': 2, 'total': 27.98, 'status': 'Delivered'},
    {'id': '#FG2374', 'date': 'Feb 28, 2026', 'items': 5, 'total': 68.45, 'status': 'Delivered'},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSavedPhoto();
  }

  // Saved photo load karo
  Future<void> _loadSavedPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_keyPhoto) ?? '';
    if (path.isNotEmpty && File(path).existsSync()) {
      localPhotoPath.value = path;
    }
  }

  // ✅ Camera ya Gallery — bottom sheet dikhao
  void showPhotoOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.camera_alt_rounded, color: Color(0xFFFF6B35))),
              title: const Text('Camera', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Photo click karo'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.photo_library_rounded, color: Color(0xFFFF6B35))),
              title: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Gallery se choose karo'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            if (localPhotoPath.value.isNotEmpty) ...[
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.red)),
                title: const Text('Remove Photo',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
                onTap: () {
                  Get.back();
                  _removePhoto();
                },
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Image pick karo
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null) {
        localPhotoPath.value = image.path;
        // SharedPreferences mein save karo
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyPhoto, image.path);
        Get.snackbar('✅ Photo Updated', 'Profile photo successfully update ho gaya',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar('Error', 'Photo select karne mein problem aayi',
        snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Photo remove karo
  Future<void> _removePhoto() async {
    localPhotoPath.value = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPhoto);
    Get.snackbar('Photo Removed', 'Profile photo remove ho gaya',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2));
  }

  // Logout
  Future<void> confirmLogout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}