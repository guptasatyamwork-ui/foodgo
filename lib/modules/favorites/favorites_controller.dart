// lib/modules/favorites/favorites_controller.dart

import 'package:flutter/material.dart';
import 'package:foodgo/core/sevice/api_sevice.dart';
import 'package:foodgo/modules/food_model.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final RxSet<String>     favoriteFoodIds = <String>{}.obs;
  final RxList<FoodModel> favoriteFoods   = <FoodModel>[].obs;

  // ✅ API se load hogi list — koi static fallback nahi
  List<FoodModel> _allFoods = [];

  @override
  void onInit() {
    super.onInit();
    _loadAllFoods();
    ever(favoriteFoodIds, (_) => _updateFavoriteList());
  }

  Future<void> _loadAllFoods() async {
    try {
      _allFoods = await ApiService.getAllFoods();
      debugPrint('✅ [Favorites] Foods loaded: ${_allFoods.length}');
    } catch (e) {
      // API off — empty, koi static data nahi
      _allFoods = [];
      debugPrint('❌ [Favorites] API error: $e');
    }
    _updateFavoriteList();
  }

  void _updateFavoriteList() {
    favoriteFoods.value = _allFoods
        .where((food) => favoriteFoodIds.contains(food.id))
        .toList();
  }

  void toggleFavorite(String foodId) {
    if (favoriteFoodIds.contains(foodId)) {
      favoriteFoodIds.remove(foodId);
    } else {
      favoriteFoodIds.add(foodId);
    }
  }

  bool isFavorite(String foodId) => favoriteFoodIds.contains(foodId);

  void clearAllFavorites() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Favorites',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Are you sure you want to remove all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              favoriteFoodIds.clear();
              Get.back();
              Get.snackbar(
                'Cleared',
                'All favorites removed',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text('Clear',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}