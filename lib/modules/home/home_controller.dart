// lib/modules/home/home_controller.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodgo/core/sevice/api_sevice.dart';
import 'package:foodgo/core/sevice/cart_service.dart';
import 'package:foodgo/modules/food_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../routes/app_pages.dart';
import '../favorites/favorites_controller.dart';

class HomeController extends GetxController {
  final CartService cartService            = Get.find<CartService>();
  final ClaudeVisionService _visionService = ClaudeVisionService.instance;
  FavoritesController get _favCtrl         => Get.find<FavoritesController>();

  // ─── Observables ──────────────────────────────────────────────────────────
  final RxInt    selectedCategoryIndex   = 0.obs;
  final RxString searchQuery             = ''.obs;
  final RxBool   isLoading               = true.obs;
  final RxBool   isApiError              = false.obs; // API off/error flag

  final RxList<FoodModel> displayedFoods = <FoodModel>[].obs;
  final RxList<FoodModel> popularFoods   = <FoodModel>[].obs;
  final RxInt    bottomNavIndex          = 0.obs;
  final RxMap<String, int> foodLocalQty  = <String, int>{}.obs;

  // ─── Camera state ─────────────────────────────────────────────────────────
  final RxBool    isScanningCamera = false.obs;
  final RxString  detectedLabel    = ''.obs;
  final Rx<File?> capturedImage    = Rx<File?>(null);

  // ─── Search ───────────────────────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();

  // ─── Categories ───────────────────────────────────────────────────────────
  final List<String> categories = [
    'All', 'Combos', 'Burgers', 'Pizza', 'Drinks',
  ];

  final List<Map<String, String>> categoryEmojis = [
    {'label': 'All',     'emoji': '🍽️'},
    {'label': 'Combos',  'emoji': '🎁'},
    {'label': 'Burgers', 'emoji': '🍔'},
    {'label': 'Pizza',   'emoji': '🍕'},
    {'label': 'Drinks',  'emoji': '🥤'},
  ];

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadFoods();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _filterFoods();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ─── Food loading — API only, no fallback ─────────────────────────────────
  Future<void> loadFoods() async {
    isLoading.value  = true;
    isApiError.value = false;

    try {
      final category = categories[selectedCategoryIndex.value];

      final results = await (category == 'All'
          ? ApiService.getAllFoods()
          : ApiService.getFoodsByCategory(category));

      final popular = await ApiService.getPopularFoods();

      displayedFoods.value = results;
      popularFoods.value   = popular;
      isApiError.value     = false;

      debugPrint('✅ [API] Foods loaded: ${results.length}');
    } catch (e) {
      // API off ya error — empty list + error flag
      displayedFoods.value = [];
      popularFoods.value   = [];
      isApiError.value     = true;
      debugPrint('❌ [API] Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectCategory(int index) async {
    selectedCategoryIndex.value = index;
    searchController.clear();
    detectedLabel.value = '';
    capturedImage.value = null;
    await loadFoods();
  }

  Future<void> _filterFoods() async {
    if (searchQuery.value.isEmpty) {
      await loadFoods();
      return;
    }

    isLoading.value  = true;
    isApiError.value = false;

    try {
      displayedFoods.value = await ApiService.searchFoods(searchQuery.value);
      isApiError.value     = false;
      debugPrint('✅ [API] Search: ${displayedFoods.length}');
    } catch (e) {
      displayedFoods.value = [];
      isApiError.value     = true;
      debugPrint('❌ [API] Search error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Qty ──────────────────────────────────────────────────────────────────
  int  getLocalQty(String foodId)       => foodLocalQty[foodId] ?? 0;
  void incrementLocalQty(String foodId) =>
      foodLocalQty[foodId] = (foodLocalQty[foodId] ?? 0) + 1;
  void decrementLocalQty(String foodId) {
    final c = foodLocalQty[foodId] ?? 0;
    if (c > 0) foodLocalQty[foodId] = c - 1;
  }
  void resetLocalQty(String foodId) => foodLocalQty[foodId] = 0;

  // ─── Favorites ────────────────────────────────────────────────────────────
  void toggleFavorite(String foodId) => _favCtrl.toggleFavorite(foodId);
  bool isFavorite(String foodId)     => _favCtrl.isFavorite(foodId);

  void clearCameraSearch() {
    capturedImage.value = null;
    detectedLabel.value = '';
    loadFoods();
  }

  // ─── Related products — API only ──────────────────────────────────────────
  Future<List<FoodModel>> getRelatedProducts(FoodModel detected) async {
    try {
      final all  = await ApiService.getFoodsByCategory(detected.category);
      final same = all.where((f) => f.id != detected.id).toList();

      return (same.map((f) {
        final score = (f.rating * 10) -
            ((f.price - detected.price).abs() * 0.5) +
            (f.isPopular ? 5.0 : 0.0);
        return _ScoredFood(food: f, score: score);
      }).toList()
            ..sort((a, b) => b.score.compareTo(a.score)))
          .map((s) => s.food)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Camera flow ────────────────────────────────────────────────────────────
  Future<void> onCameraButtonTapped() async {
    final XFile? photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
      maxWidth: 800,
    );
    if (photo == null) return;

    capturedImage.value    = File(photo.path);
    isScanningCamera.value = true;
    detectedLabel.value    = '';

    debugPrint('📸 [Camera] Photo: ${photo.path}');

    final bytes       = await File(photo.path).readAsBytes();
    final base64Image = base64Encode(bytes);

    final String? category =
        await _visionService.detectFoodCategory(base64Image);

    isScanningCamera.value = false;
    debugPrint('🏁 [Camera] Category: $category');

    FoodModel? detectedProduct;
    List<FoodModel> related = [];

    if (category != null) {
      detectedProduct = await _getBestMatch(category);
      if (detectedProduct != null) {
        related = await getRelatedProducts(detectedProduct);
      }
    }

    detectedLabel.value = category ?? '';

    Get.toNamed(
      Routes.VISUAL_SEARCH_RESULT,
      arguments: {
        'capturedImagePath': photo.path,
        'category':          category,
        'detectedProduct':   detectedProduct,
        'relatedProducts':   related,
      },
    );
  }

  Future<FoodModel?> _getBestMatch(String category) async {
    try {
      final foods = await ApiService.getFoodsByCategory(category);
      if (foods.isEmpty) return null;
      return foods.firstWhere((f) => f.isPopular, orElse: () => foods.first);
    } catch (_) {
      return null;
    }
  }
}

class _ScoredFood {
  final FoodModel food;
  final double    score;
  const _ScoredFood({required this.food, required this.score});
}