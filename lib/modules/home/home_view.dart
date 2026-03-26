import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../routes/app_pages.dart';
import '../../core/sevice/cart_service.dart';
import '../../widgets/food_card.dart';
import '../favorites/favorites_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Get.find<CartService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(cartService)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _buildSearchBarWithCamera(),
              ),
            ),
            SliverToBoxAdapter(child: _buildCapturedImagePreview()),
            SliverToBoxAdapter(child: _buildBanner()),
            SliverToBoxAdapter(child: _buildCategories()),

            // Popular Now header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('🔥 Popular Now',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    GestureDetector(
                      onTap: () => controller.selectCategory(0),
                      child: const Text('See All',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildPopularList()),

            // All items header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Obx(() => Text(
                      controller.selectedCategoryIndex.value == 0
                          ? '🍽️ All Items'
                          : '${controller.categoryEmojis[controller.selectedCategoryIndex.value]['emoji']!}  '
                              '${controller.categories[controller.selectedCategoryIndex.value]}',
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    )),
              ),
            ),

            // ── Food grid ─────────────────────────────────────────────────
            Obx(() {
              // Loading
              if (controller.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              // ❌ API off ya error — Data Not Found
              if (controller.isApiError.value) {
                return SliverToBoxAdapter(
                  child: _buildDataNotFound(),
                );
              }

              // Empty search result
              if (controller.displayedFoods.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('😕', style: TextStyle(fontSize: 40)),
                          SizedBox(height: 12),
                          Text('No items found',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // ✅ Data hai — grid dikhao
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final food = controller.displayedFoods[index];
                      return Obx(() {
                        final favCtrl = Get.find<FavoritesController>();
                        return FoodCard(
                          food: food,
                          isFavorite: favCtrl.isFavorite(food.id),
                          onFavoriteTap: () =>
                              controller.toggleFavorite(food.id),
                        );
                      });
                    },
                    childCount: controller.displayedFoods.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                ),
              );
            }),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  ❌  Data Not Found — API off hone par
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildDataNotFound() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wifi_off_rounded,
                size: 44, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const Text(
            'Data Not Found',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Server se connect nahi ho saka.\nInternet check karo ya baad mein try karo.',
            style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.loadFoods,
              icon:  const Icon(Icons.refresh_rounded,
                  color: Colors.white, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar with camera ─────────────────────────────────────────────────
  Widget _buildSearchBarWithCamera() {
    return Obx(() {
      final isScanning = controller.isScanningCamera.value;
      return Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Row(children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(Icons.search_rounded,
                color: AppColors.textLight, size: 22),
          ),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                hintText: 'Search food...',
                hintStyle: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Container(
            width: 1, height: 26,
            color: AppColors.textLight.withOpacity(0.25),
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
          GestureDetector(
            onTap: isScanning ? null : controller.onCameraButtonTapped,
            child: Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: isScanning
                    ? AppColors.primary.withOpacity(0.7)
                    : AppColors.primary,
                borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(16)),
              ),
              child: isScanning
                  ? const Center(
                      child: SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      ),
                    )
                  : const Icon(Icons.camera_alt_rounded,
                      color: Colors.white, size: 22),
            ),
          ),
        ]),
      );
    });
  }

  // ── Captured image preview ─────────────────────────────────────────────────
  Widget _buildCapturedImagePreview() {
    return Obx(() {
      final image = controller.capturedImage.value;
      final label = controller.detectedLabel.value;
      if (image == null) return const SizedBox.shrink();

      const Map<String, String> emojiMap = {
        'Pizza': '🍕', 'Burgers': '🍔',
        'Drinks': '🥤', 'Combos': '🎁',
      };
      final String emoji = emojiMap[label] ?? '🔍';

      return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 10),
          ],
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(image,
                width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📷 Visual Search',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(
                  label.isNotEmpty
                      ? '$emoji  $label results'
                      : 'Analyzing...',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: controller.clearCameraSearch,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100, shape: BoxShape.circle),
              child: const Icon(Icons.close_rounded,
                  size: 16, color: AppColors.textSecondary),
            ),
          ),
        ]),
      );
    });
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(CartService cartService) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.location_on,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 4),
              const Text('Deliver to',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
              const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.primary, size: 18),
            ]),
            const Text('New York, USA',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ]),
          Row(children: [
            Obx(() => badges.Badge(
                  showBadge: cartService.itemCount > 0,
                  badgeContent: Text(cartService.itemCount.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 10)),
                  badgeStyle: const badges.BadgeStyle(
                      badgeColor: AppColors.primary),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.CART),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 10)
                          ]),
                      child: const Icon(Icons.shopping_bag_outlined,
                          color: AppColors.textPrimary, size: 22),
                    ),
                  ),
                )),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.PROFILE),
              child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80'),
                          fit: BoxFit.cover))),
            ),
          ]),
        ],
      ),
    );
  }

  // ── Banner ─────────────────────────────────────────────────────────────────
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 150,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        Positioned(
            right: 0, top: 0, bottom: 0,
            child: CachedNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&q=80',
                width: 150,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.25),
                colorBlendMode: BlendMode.darken,
                placeholder: (_, __) => const SizedBox.shrink())),
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 160, 14),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text('🎉 Special Offer',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600))),
                  const SizedBox(height: 6),
                  const Text('Get 30% OFF\nyour first order!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.25)),
                  const SizedBox(height: 8),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text('Order Now',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700))),
                ])),
      ]),
    );
  }

  // ── Categories ─────────────────────────────────────────────────────────────
  Widget _buildCategories() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Text('Categories',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary))),
      SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            return Obx(() => CategoryChip(
                  label: controller.categoryEmojis[index]['label']!,
                  emoji: controller.categoryEmojis[index]['emoji']!,
                  isSelected:
                      controller.selectedCategoryIndex.value == index,
                  onTap: () => controller.selectCategory(index),
                ));
          },
        ),
      ),
    ]);
  }

  // ── Popular list ───────────────────────────────────────────────────────────
  Widget _buildPopularList() {
    return Obx(() {
      if (controller.isApiError.value || controller.popularFoods.isEmpty) {
        return const SizedBox(height: 8);
      }
      return SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: controller.popularFoods.length,
          itemBuilder: (context, index) {
            final food = controller.popularFoods[index];
            return GestureDetector(
              onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL,
                  arguments: {'food': food, 'qty': 1}),
              child: Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 15,
                          offset: const Offset(0, 5))
                    ]),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: CachedNetworkImage(
                              imageUrl: food.imageUrl,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (ctx, url) => Container(
                                  height: 130,
                                  color: Colors.grey[100]))),
                      Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(food.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Row(children: [
                                  const Icon(Icons.star_rounded,
                                      color: AppColors.star, size: 14),
                                  const SizedBox(width: 2),
                                  Text(food.rating.toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Text(
                                      '\$${food.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary)),
                                ]),
                              ])),
                    ]),
              ),
            );
          },
        ),
      );
    });
  }

  // ── Bottom nav ─────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Obx(() => Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -5))
              ]),
          child: BottomNavigationBar(
            currentIndex: controller.bottomNavIndex.value,
            onTap: (index) {
              controller.bottomNavIndex.value = index;
              if (index == 1) Get.toNamed(Routes.CART);
              if (index == 2) Get.toNamed(Routes.FAVORITES);
              if (index == 3) Get.toNamed(Routes.PROFILE);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textLight,
            selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 11),
            elevation: 0,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(
                icon: Obx(() {
                  final cs = Get.find<CartService>();
                  return badges.Badge(
                    showBadge: cs.itemCount > 0,
                    badgeContent: Text(cs.itemCount.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 8)),
                    badgeStyle: const badges.BadgeStyle(
                        badgeColor: AppColors.primary),
                    child: const Icon(Icons.shopping_bag_outlined),
                  );
                }),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Obx(() {
                  final favCtrl = Get.find<FavoritesController>();
                  return badges.Badge(
                    showBadge: favCtrl.favoriteFoods.isNotEmpty,
                    badgeContent: Text(
                        favCtrl.favoriteFoods.length.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 8)),
                    badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.red),
                    child: const Icon(Icons.favorite_border_rounded),
                  );
                }),
                label: 'Favorites',
              ),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  label: 'Profile'),
            ],
          ),
        ));
  }
}