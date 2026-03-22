import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodgo/core/sevice/auth_service.dart';
import 'package:foodgo/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/sevice/order_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final OrderService orderService = Get.find<OrderService>();
  final ImagePicker _picker = ImagePicker();

  RxString get name => _authService.userName;
  RxString get email => _authService.userEmail;

  final RxString address = '123 Main Street, New York, NY 10001'.obs;
  final RxString phone = '+1 (555) 123-4567'.obs;
  static const String _keyAddress = 'profile_address';
  static const String _keyPhone = 'profile_phone';

  final RxString localPhotoPath = ''.obs;
  static const String _keyPhoto = 'profile_photo_path';

  // ✅ Live order count aur orders OrderService se
  RxList<OrderModel> get orderHistory => orderService.orders;
  int get totalOrders => orderService.orders.length;

  @override
  void onInit() {
    super.onInit();
    _loadSavedPhoto();
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString(_keyAddress) ?? '';
    final savedPhone = prefs.getString(_keyPhone) ?? '';
    if (savedAddress.isNotEmpty) address.value = savedAddress;
    if (savedPhone.isNotEmpty) phone.value = savedPhone;
  }

  Future<void> _loadSavedPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_keyPhoto) ?? '';
    if (path.isNotEmpty && File(path).existsSync()) {
      localPhotoPath.value = path;
    }
  }

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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Color(0xFFFF6B35)),
              ),
              title: const Text('Camera', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Photo click karo'),
              onTap: () async {
                Get.back();
                await Future.delayed(const Duration(milliseconds: 300));
                pickImageFromCamera();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.photo_library_rounded, color: Color(0xFFFF6B35)),
              ),
              title: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Gallery se choose karo'),
              onTap: () async {
                Get.back();
                await Future.delayed(const Duration(milliseconds: 300));
                pickImageFromGallery();
              },
            ),
            if (localPhotoPath.value.isNotEmpty) ...[
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                ),
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

  void goToEditProfile() async {
    final result = await Get.toNamed(
      Routes.EDIT_PROFILE,
      arguments: {
        'name': name.value,
        'phone': phone.value,
        'address': address.value,
      },
    );
    if (result != null) {
      _authService.userName.value = result['name'];
      phone.value = result['phone'];
      address.value = result['address'];
    }
  }

  void pickImageFromCamera() => _pickImage(ImageSource.camera);
  void pickImageFromGallery() => _pickImage(ImageSource.gallery);

  Future<void> _pickImage(ImageSource source) async {
    PermissionStatus status;
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      if (GetPlatform.isAndroid) {
        status = await Permission.photos.request();
        if (status.isDenied) status = await Permission.storage.request();
      } else {
        status = await Permission.photos.request();
      }
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      Get.snackbar('Permission Required', 'Please allow access in Settings',
          snackPosition: SnackPosition.BOTTOM,
          mainButton: TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Open Settings', style: TextStyle(color: Colors.white)),
          ));
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
          source: source, maxWidth: 512, maxHeight: 512, imageQuality: 85);
      if (image != null) {
        localPhotoPath.value = image.path;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyPhoto, image.path);
        Get.snackbar('✅ Photo Updated', 'Profile photo successfully updated',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not select photo: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _removePhoto() async {
    localPhotoPath.value = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPhoto);
    Get.snackbar('Photo Removed', 'Profile photo remove ho gaya',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2));
  }

  Future<void> confirmLogout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}