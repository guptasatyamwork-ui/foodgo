import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodgo/modules/food_model.dart';
import '../core/theme/app_theme.dart';
import '../routes/app_pages.dart';
import '../core/sevice/cart_service.dart';
import '../modules/home/home_controller.dart';
import 'package:get/get.dart';

class FoodCard extends StatelessWidget {
  final FoodModel food;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const FoodCard({
    super.key,
    required this.food,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartService = Get.find<CartService>();
    final homeCtrl = Get.find<HomeController>();

    return GestureDetector(
      onTap: onTap ?? () {
        // ✅ Current local qty ke saath detail screen pe jao
        final qty = homeCtrl.getLocalQty(food.id);
        Get.toNamed(
          Routes.PRODUCT_DETAIL,
          arguments: {'food': food, 'qty': qty > 0 ? qty : 1},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Image ──────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: CachedNetworkImage(
                    imageUrl: food.imageUrl,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(height: 110, color: const Color(0xFFF3F4F6)),
                    errorWidget: (context, url, error) => Container(
                      height: 110,
                      color: const Color(0xFFF3F4F6),
                      child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 15,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: food.isVeg ? Colors.green : AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      food.isVeg ? '🥦 Veg' : '🍖 Non',
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),

            // ── Content ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.star, size: 11),
                      const SizedBox(width: 2),
                      Text(food.rating.toString(),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Flexible(
                        child: Text(' (${food.reviewCount})',
                            style: const TextStyle(fontSize: 10, color: AppColors.textLight),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${food.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                  const SizedBox(height: 5),

                  // ✅ HomeController se qty observe karo — globally synced
                  Obx(() {
                    final qty = homeCtrl.getLocalQty(food.id);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (qty > 0) ...[
                              _qtyBtn(
                                icon: Icons.remove,
                                onTap: () => homeCtrl.decrementLocalQty(food.id),
                                filled: false,
                              ),
                              const SizedBox(width: 5),
                              Text(qty.toString(),
                                  style: const TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                              const SizedBox(width: 5),
                            ],
                            _qtyBtn(
                              icon: Icons.add,
                              onTap: () => homeCtrl.incrementLocalQty(food.id),
                              filled: true,
                            ),
                          ],
                        ),
                        if (qty >= 1)
                          GestureDetector(
                            onTap: () {
                              // ✅ Cart mein add karo
                              if (cartService.isInCart(food.id)) {
                                for (int i = 0; i < qty; i++) {
                                  cartService.incrementQuantity(food.id);
                                }
                              } else {
                                cartService.addToCart(food);
                                for (int i = 1; i < qty; i++) {
                                  cartService.incrementQuantity(food.id);
                                }
                              }
                              // ✅ Reset — 0 ho jao
                              homeCtrl.resetLocalQty(food.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Add',
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap, required bool filled}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: filled ? null : Border.all(color: AppColors.primary, width: 1.2),
        ),
        child: Icon(icon, color: filled ? Colors.white : AppColors.primary, size: 13),
      ),
    );
  }
}

// ── CategoryChip ──────────────────────────────────────────────────
class CategoryChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppColors.primary.withOpacity(0.35) : AppColors.cardShadow,
              blurRadius: 8, offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
            )),
          ],
        ),
      ),
    );
  }
}

// ── SectionHeader ─────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionText, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionText!,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
          ),
      ],
    );
  }
}

// ── CustomSearchBar ───────────────────────────────────────────────
class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const CustomSearchBar({super.key, required this.controller, this.hint = 'Search burgers, pizza, drinks...'});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textLight, size: 20),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.tune_rounded, color: Colors.white, size: 15),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          isDense: true,
        ),
      ),
    );
  }
}