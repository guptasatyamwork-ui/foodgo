import 'dart:convert';
import 'package:foodgo/modules/food_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ════════════════════════════════════════════════════
  //  Base URL — development mein localhost, production
  //  mein apna deployed URL daalo
  //
  //  Android emulator ke liye: 10.0.2.2 (localhost nahi)
  //  Real device ke liye: apne PC ka IP address
  //  Production ke liye: https://foodgo-api.railway.app
  // ════════════════════════════════════════════════════
  static const String _baseUrl = 'http://10.0.2.2:3000';
  // static const String _baseUrl = 'http://192.168.1.5:3000'; // real device
  // static const String _baseUrl = 'https://your-app.railway.app'; // production

  static final _client = http.Client();

  // ─── Helper ──────────────────────────────────────────
  static List<FoodModel> _parseList(String body) {
    final json = jsonDecode(body);
    final List data = json['data'] as List;
    return data.map((e) => FoodModel.fromJson(e)).toList();
  }

  // ─── GET /foods ───────────────────────────────────────
  static Future<List<FoodModel>> getAllFoods() async {
    final res = await _client.get(Uri.parse('$_baseUrl/foods'));
    if (res.statusCode == 200) return _parseList(res.body);
    throw Exception('getAllFoods failed: ${res.statusCode}');
  }

  // ─── GET /foods/popular ───────────────────────────────
  static Future<List<FoodModel>> getPopularFoods() async {
    final res = await _client.get(Uri.parse('$_baseUrl/foods/popular'));
    if (res.statusCode == 200) return _parseList(res.body);
    throw Exception('getPopularFoods failed: ${res.statusCode}');
  }

  // ─── GET /foods/category/:category ───────────────────
  static Future<List<FoodModel>> getFoodsByCategory(String category) async {
    final res = await _client.get(
        Uri.parse('$_baseUrl/foods/category/$category'));
    if (res.statusCode == 200) return _parseList(res.body);
    throw Exception('getFoodsByCategory failed: ${res.statusCode}');
  }

  // ─── GET /foods/search?q= ─────────────────────────────
  static Future<List<FoodModel>> searchFoods(String query) async {
    final uri = Uri.parse('$_baseUrl/foods/search')
        .replace(queryParameters: {'q': query});
    final res = await _client.get(uri);
    if (res.statusCode == 200) return _parseList(res.body);
    throw Exception('searchFoods failed: ${res.statusCode}');
  }

  // ─── GET /foods/:id ───────────────────────────────────
  static Future<FoodModel> getFoodById(String id) async {
    final res = await _client.get(Uri.parse('$_baseUrl/foods/$id'));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return FoodModel.fromJson(json['data']);
    }
    throw Exception('getFoodById failed: ${res.statusCode}');
  }
}