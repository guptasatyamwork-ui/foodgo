import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../{core,modules,widgets,routes,models,services}/models/food_model.dart';
import '../../services/food_service.dart';
import '../../services/cart_service.dart';

class HomeController extends GetxController {
  final CartService cartService = Get.find<CartService>();

  final RxInt selectedCategoryIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxList<FoodModel> displayedFoods = <FoodModel>[].obs;
  final RxList<FoodModel> popularFoods = <FoodModel>[].obs;
  final RxSet<String> favoriteFoodIds = <String>{}.obs;
  final RxInt bottomNavIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();

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

  void toggleFavorite(String foodId) {
    if (favoriteFoodIds.contains(foodId)) {
      favoriteFoodIds.remove(foodId);
    } else {
      favoriteFoodIds.add(foodId);
    }
  }

  bool isFavorite(String foodId) => favoriteFoodIds.contains(foodId);

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
