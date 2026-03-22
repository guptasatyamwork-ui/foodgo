import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme/app_theme.dart';
import '../../routes/app_pages.dart';
import '../../modules/food_model.dart';

/// Visual Search Result Screen
///
/// Arguments (Get.arguments):
///   'detectedLabel'      — String
///   'capturedImagePath'  — String
///   'detectedProduct'    — FoodModel   (best match)
///   'relatedProducts'    — List<FoodModel>  (smart scored — same category,
///                                            sorted by rating + price proximity)
class VisualSearchResultView extends StatelessWidget {
  const VisualSearchResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final args            = Get.arguments as Map<String, dynamic>;
    final String label    = args['detectedLabel']     ?? '';
    final String imgPath  = args['capturedImagePath'] ?? '';
    final FoodModel main  = args['detectedProduct']   as FoodModel;
    final List<FoodModel> related =
        List<FoodModel>.from(args['relatedProducts'] ?? []);

    const Map<String, String> emojiMap = {
      'Burgers': '🍔', 'Pizza': '🍕',
      'Drinks':  '🥤', 'Combos': '🎁',
    };
    final String emoji = emojiMap[label] ?? '🍽️';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(label, emoji),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Captured photo ──────────────────────────────────────────
            if (imgPath.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(File(imgPath),
                    width: double.infinity,
                    height: 190,
                    fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),

              // Detected badge
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.auto_awesome_rounded,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('$emoji  $label detected',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ]),
                ),
              ]),
              const SizedBox(height: 22),
            ],

            // ── Best Match ──────────────────────────────────────────────
            const _SectionLabel(text: '✅ Best Match'),
            const SizedBox(height: 12),
            _MainCard(food: main),
            const SizedBox(height: 28),

            // ── Related — same category, smart order ────────────────────
            if (related.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionLabel(
                      text: '$emoji  Related ${main.category}'),
                  Text('${related.length} items',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 4),
              // Subtitle — explains why these are related
              Text(
                'Same category • Sorted by rating & price',
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary.withOpacity(0.7)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 218,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: related.length,
                  itemBuilder: (_, i) => _RelatedCard(food: related[i]),
                ),
              ),
            ] else ...[
              // No related products — iska matlab category mein sirf ek item tha
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Colors.grey, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Is category mein abhi sirf yahi item available hai.',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ),
                ]),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(String label, String emoji) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 16, color: AppColors.textPrimary),
        ),
      ),
      title: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Visual Search',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ]),
      ]),
      actions: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(children: [
              Icon(Icons.camera_alt_rounded,
                  size: 14, color: AppColors.primary),
              SizedBox(width: 4),
              Text('Rescan',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary)),
            ]),
          ),
        ),
      ],
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary));
  }
}

// ─── Main product card ────────────────────────────────────────────────────────
class _MainCard extends StatelessWidget {
  final FoodModel food;
  const _MainCard({required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL,
          arguments: {'food': food, 'qty': 1}),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color:  AppColors.cardShadow,
                blurRadius: 16,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + badge
            Stack(children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: food.imageUrl,
                  width: double.infinity,
                  height: 195,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(height: 195, color: Colors.grey[100]),
                ),
              ),
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded,
                          color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text('Best Match',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              if (food.isPopular)
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text('🔥 Popular',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
            ]),

            // Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.star, size: 16),
                    const SizedBox(width: 4),
                    Text(food.rating.toString(),
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(food.category,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                    ),
                    const Spacer(),
                    Text('\$${food.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary)),
                  ]),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(
                          Routes.PRODUCT_DETAIL,
                          arguments: {'food': food, 'qty': 1}),
                      icon: const Icon(Icons.shopping_bag_outlined,
                          color: Colors.white, size: 18),
                      label: const Text('View & Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                    ),
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

// ─── Related product card ─────────────────────────────────────────────────────
class _RelatedCard extends StatelessWidget {
  final FoodModel food;
  const _RelatedCard({required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL,
          arguments: {'food': food, 'qty': 1}),
      child: Container(
        width: 152,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color:  AppColors.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: food.imageUrl,
                  width: double.infinity,
                  height: 112,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(height: 112, color: Colors.grey[100]),
                ),
              ),
              if (food.isPopular)
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('🔥',
                        style: TextStyle(fontSize: 10)),
                  ),
                ),
            ]),

            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.star, size: 12),
                    const SizedBox(width: 3),
                    Text(food.rating.toString(),
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text('\$${food.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary)),
                  ]),
                  const SizedBox(height: 8),
                  // Quick add button
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('View',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ),
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