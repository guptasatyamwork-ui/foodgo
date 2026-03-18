import 'package:flutter/material.dart';
import 'package:foodgo/{core,modules,widgets,routes,models,services}/models/food_model.dart';
import 'package:get/get.dart';
import '../../services/food_service.dart';

class FavoritesController extends GetxController {
  // ✅ HomeController ke favoriteFoodIds se sync hoga
  final RxSet<String> favoriteFoodIds = <String>{}.obs;
  final RxList<FoodModel> favoriteFoods = <FoodModel>[].obs;

  // Jab bhi favoriteFoodIds change ho — list update karo
  @override
  void onInit() {
    super.onInit();
    ever(favoriteFoodIds, (_) => _updateFavoriteList());
  }

  void _updateFavoriteList() {
    final allFoods = FoodService.getAllFoods();
    favoriteFoods.value = allFoods
        .where((food) => favoriteFoodIds.contains(food.id))
        .toList();
  }

  // ✅ Toggle favorite — HomeController se bhi call hoga
  void toggleFavorite(String foodId) {
    if (favoriteFoodIds.contains(foodId)) {
      favoriteFoodIds.remove(foodId);
    } else {
      favoriteFoodIds.add(foodId);
    }
  }

  bool isFavorite(String foodId) => favoriteFoodIds.contains(foodId);

  // ✅ Saare favorites clear karo
  void clearAllFavorites() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Favorites',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to remove all favorites?'),
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
                '🗑️ Cleared',
                'All favorites removed',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}