import 'package:flutter/material.dart';
import 'package:foodgo/modules/food_model.dart';
import 'package:get/get.dart';
import '../../services/food_service.dart';
import '../../services/cart_service.dart';
import '../favorites/favorites_controller.dart';

class HomeController extends GetxController {
  final CartService cartService = Get.find<CartService>();
  FavoritesController get _favCtrl => Get.find<FavoritesController>();

  final RxInt selectedCategoryIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxList<FoodModel> displayedFoods = <FoodModel>[].obs;
  final RxList<FoodModel> popularFoods = <FoodModel>[].obs;
  final RxInt bottomNavIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();

  // ✅ Per-food local qty — food id se qty track hogi globally
  // Favorites se bhi same qty milegi
  final RxMap<String, int> foodLocalQty = <String, int>{}.obs;

  final List<String> categories = ['All', 'Combos', 'Burgers', 'Pizza', 'Drinks'];

  final List<Map<String, String>> categoryEmojis = [
    {'label': 'All', 'emoji': '🍽️'},
    {'label': 'Combos', 'emoji': '🎁'},
    {'label': 'Burgers', 'emoji': '🍔'},
    {'label': 'Pizza', 'emoji': '🍕'},
    {'label': 'Drinks', 'emoji': '🥤'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadFoods();
    popularFoods.value = FoodService.getPopularFoods();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _filterFoods();
    });
  }

  void loadFoods() {
    displayedFoods.value = FoodService.getFoodsByCategory(
      categories[selectedCategoryIndex.value],
    );
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    searchController.clear();
    loadFoods();
  }

  void _filterFoods() {
    if (searchQuery.value.isEmpty) {
      loadFoods();
    } else {
      displayedFoods.value = FoodService.searchFoods(searchQuery.value);
    }
  }

  // ✅ Local qty getters — food card aur favorites dono use karein
  int getLocalQty(String foodId) => foodLocalQty[foodId] ?? 0;

  void incrementLocalQty(String foodId) {
    foodLocalQty[foodId] = (foodLocalQty[foodId] ?? 0) + 1;
  }

  void decrementLocalQty(String foodId) {
    final current = foodLocalQty[foodId] ?? 0;
    if (current > 0) {
      foodLocalQty[foodId] = current - 1;
    }
  }

  void resetLocalQty(String foodId) {
    foodLocalQty[foodId] = 0;
  }

  // ✅ FavoritesController ko delegate
  void toggleFavorite(String foodId) => _favCtrl.toggleFavorite(foodId);
  bool isFavorite(String foodId) => _favCtrl.isFavorite(foodId);

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}