import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../favorites/favorites_controller.dart';
import 'product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: 340, width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: controller.food.imageUrl,
              fit: BoxFit.cover,
              placeholder: (ctx, url) => Container(color: Colors.grey[200]),
            ),
          ),
          // Back + Favorite buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16, right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleButton(Icons.arrow_back_ios_new_rounded, () => Get.back()),
                // ✅ FavoritesController se directly observe
                Obx(() {
                  final favCtrl = Get.find<FavoritesController>();
                  final isFav = favCtrl.favoriteFoodIds.contains(controller.food.id);
                  return _circleButton(
                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    controller.toggleFavorite,
                    color: isFav ? Colors.red : AppColors.textPrimary,
                  );
                }),
              ],
            ),
          ),
          // Content Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.55,
            maxChildSize: 0.85,
            builder: (ctx, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Container(width: 40, height: 4,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)),
                        child: Text(controller.food.category,
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text(controller.food.name,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary, height: 1.2))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.star.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12)),
                            child: Row(children: [
                              const Icon(Icons.star_rounded, color: AppColors.star, size: 18),
                              const SizedBox(width: 4),
                              Text(controller.food.rating.toString(),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14,
                                  color: AppColors.textPrimary)),
                            ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${controller.food.reviewCount} reviews  •  ${controller.food.calories} cal  •  ${controller.food.prepTime}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 16),
                      Text(controller.food.description,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
                      const SizedBox(height: 24),
                      const Text('🌶️ Spicy Level',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      Obx(() => Column(children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: Colors.grey[200],
                            thumbColor: AppColors.primary,
                            overlayColor: AppColors.primary.withOpacity(0.2),
                            trackHeight: 6),
                          child: Slider(
                            value: controller.spicyLevel.value,
                            min: 0, max: 3, divisions: 3,
                            onChanged: controller.setSpicyLevel),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: ['None', 'Mild', 'Medium', 'Hot'].asMap().entries.map((e) =>
                            Text(e.value, style: TextStyle(
                              fontSize: 12,
                              fontWeight: controller.spicyLevel.value.round() == e.key
                                  ? FontWeight.w700 : FontWeight.w400,
                              color: controller.spicyLevel.value.round() == e.key
                                  ? AppColors.primary : AppColors.textLight))).toList()),
                      ])),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Quantity',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          Obx(() => Row(children: [
                            _quantityBtn(Icons.remove, controller.decrement),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(controller.quantity.value.toString(),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary))),
                            _quantityBtn(Icons.add, controller.increment, filled: true),
                          ])),
                        ],
                      ),
                      const SizedBox(height: 28),
                      // ✅ Add to Cart — cart screen pe jao
                      Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_bag_outlined),
                              const SizedBox(width: 10),
                              Text('Add to Cart  •  \$${controller.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            ]),
                        ),
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, {Color color = AppColors.textPrimary}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white, shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10)]),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _quantityBtn(IconData icon, VoidCallback onTap, {bool filled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: filled ? null : Border.all(color: Colors.grey[300]!),
          boxShadow: filled ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)] : null),
        child: Icon(icon, color: filled ? Colors.white : AppColors.textPrimary, size: 18),
      ),
    );
  }
}