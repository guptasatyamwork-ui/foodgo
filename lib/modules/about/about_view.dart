import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import 'about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildAppInfo(),
                  const SizedBox(height: 24),
                  _buildDescriptionCard(),
                  const SizedBox(height: 20),
                  _buildFeaturesCard(),
                  const SizedBox(height: 20),
                  _buildDetailsCard(),
                  const SizedBox(height: 20),
                  _buildLegalCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 28),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              const Expanded(
                child: Text(
                  'About Foodgo',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        Container(
          width: 90, height: 90,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: const Icon(Icons.fastfood_rounded, color: Colors.white, size: 44),
        ),
        const SizedBox(height: 16),
        const Text('Foodgo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
          child: const Text('Version 1.0.0', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: const Text(
        'Foodgo is your ultimate food delivery companion. We connect you with the best local restaurants and deliver delicious meals right to your doorstep — fast, fresh, and hassle-free.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    final features = [
      {'icon': Icons.delivery_dining_rounded, 'text': 'Fast Delivery'},
      {'icon': Icons.restaurant_menu_rounded, 'text': '500+ Restaurants'},
      {'icon': Icons.star_rounded, 'text': 'Top Rated Food'},
      {'icon': Icons.track_changes_rounded, 'text': 'Live Order Tracking'},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Why Foodgo?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.8,
            children: features.map((f) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.07), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Icon(f['icon'] as IconData, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(f['text'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
              ]),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    final details = [
      {'label': 'Developer', 'value': 'Foodgo Team'},
      {'label': 'Released', 'value': 'March 2026'},
      {'label': 'Category', 'value': 'Food & Drink'},
      {'label': 'Platform', 'value': 'Android & iOS'},
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: details.asMap().entries.map((entry) => Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(entry.value['label']!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              Text(entry.value['value']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
            ]),
          ),
          if (entry.key < details.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
        ])).toList(),
      ),
    );
  }

  // ✅ Legal card — controller ke methods call ho rahe hain
  Widget _buildLegalCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _legalTile(Icons.privacy_tip_outlined, 'Privacy Policy', const Color(0xFF2196F3),
              onTap: () => controller.showPrivacyPolicy()),
          const Divider(height: 1, indent: 56),
          _legalTile(Icons.article_outlined, 'Terms of Service', const Color(0xFF4CAF50),
              onTap: () => controller.showTermsOfService()),
          const Divider(height: 1, indent: 56),
          _legalTile(Icons.cookie_outlined, 'Cookie Policy', const Color(0xFFFF9800),
              onTap: () => controller.showCookiePolicy()),
        ],
      ),
    );
  }

  Widget _legalTile(IconData icon, String title, Color color, {required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}