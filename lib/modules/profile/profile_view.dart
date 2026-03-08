import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildStats(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Account'),
                  const SizedBox(height: 12),
                  _buildMenuCard([
                    _menuItem(Icons.person_outline_rounded, 'Edit Profile', onTap: () {}),
                    _menuItem(Icons.location_on_outlined, 'My Addresses', onTap: () {}),
                    _menuItem(Icons.payment_rounded, 'Payment Methods', onTap: () {}),
                  ]),
                  const SizedBox(height: 20),
                  _sectionTitle('Order History'),
                  const SizedBox(height: 12),
                  ...controller.orderHistory.map((order) => _buildOrderCard(order)),
                  const SizedBox(height: 20),
                  _sectionTitle('More'),
                  const SizedBox(height: 12),
                  _buildMenuCard([
                    _menuItem(Icons.notifications_none_rounded, 'Notifications', onTap: () {}),
                    _menuItem(Icons.help_outline_rounded, 'Help & Support', onTap: () {}),
                    _menuItem(Icons.info_outline_rounded, 'About Foodgo', onTap: () {}),
                  ]),
                  const SizedBox(height: 16),
                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout_rounded, color: AppColors.primary),
                      label: const Text('Logout',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          child: Column(
            children: [
              Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Get.back()),
                const Expanded(
                  child: Text('My Profile', textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: Colors.white),
                  onPressed: () {}),
              ]),
              const SizedBox(height: 20),
              // ✅ Profile photo — tap karo to change
              GestureDetector(
                onTap: controller.showPhotoOptions,
                child: Stack(children: [
                  Obx(() {
                    final path = controller.localPhotoPath.value;
                    return Container(
                      width: 96, height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3)),
                      child: ClipOval(
                        child: path.isNotEmpty
                          // ✅ Local file photo
                          ? Image.file(File(path), fit: BoxFit.cover)
                          // Default network photo
                          : CachedNetworkImage(
                              imageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80',
                              fit: BoxFit.cover),
                      ),
                    );
                  }),
                  // ✅ Camera icon — tap karo
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, size: 16, color: AppColors.primary),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 14),
              Obx(() => Text(controller.name.value,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800))),
              const SizedBox(height: 4),
              Obx(() => Text(controller.email.value,
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14))),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.location_on_rounded, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text('New York, USA',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 15, offset: const Offset(0, 5))]),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _statItem('15', 'Orders'),
            _verticalDivider(),
            _statItem('3', 'Favorites'),
            _verticalDivider(),
            _statItem('⭐ 4.8', 'Rating'),
          ]),
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(children: [
      Text(value,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
    ]);
  }

  Widget _verticalDivider() =>
    Container(width: 1, height: 36, color: Colors.grey[200]);

  Widget _sectionTitle(String title) => Text(title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary));

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        children: children.asMap().entries.map((e) => Column(children: [
          e.value,
          if (e.key < children.length - 1) const Divider(height: 1, indent: 56),
        ])).toList(),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, {required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primary, size: 20)),
      title: Text(title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: const Offset(0, 3))]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.receipt_long_rounded, color: Colors.green, size: 20)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(order['id'],
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text('${order['items']} items • ${order['date']}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ]),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('\$${(order['total'] as double).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primary)),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)),
            child: Text(order['status'],
              style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600))),
        ]),
      ]),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.logout_rounded, color: AppColors.primary, size: 32)),
            const SizedBox(height: 16),
            const Text('Logout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('Are you sure you want to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Cancel',
                    style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)))),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.confirmLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Logout',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
            ]),
          ]),
        ),
      ),
    );
  }
}