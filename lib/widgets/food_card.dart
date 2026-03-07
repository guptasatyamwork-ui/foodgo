import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_theme.dart';
import '../{core,modules,widgets,routes,models,services}/models/food_model.dart';
import '../routes/app_pages.dart';
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
    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: food),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: food.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.primary : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // Veg/Non-veg badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: food.isVeg ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      food.isVeg ? '🥦 Veg' : '🍖 Non-Veg',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.star, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        food.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ' (${food.reviewCount})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '⏱ ${food.prepTime}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${food.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: food),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.3)
                  : AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.hint = 'Search for food...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 18),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
