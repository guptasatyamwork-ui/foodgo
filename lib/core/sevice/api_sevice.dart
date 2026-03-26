// lib/core/sevice/api_sevice.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodgo/modules/food_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ══════════════════════════════════════════════════════════════════════════
<<<<<<< HEAD
  //  🌐  BASE URL CONFIG
  //
  //  Real device use kar rahe ho?
  //  Step 1: CMD mein → ipconfig → IPv4 Address copy karo
  //  Step 2: Neeche _realDeviceIp mein paste karo
  //  Step 3: Phone aur PC same WiFi pe hone chahiye
  //
  //  Emulator use kar rahe ho? Kuch mat badlo — auto detect hoga
  // ══════════════════════════════════════════════════════════════════════════
  static const String _realDeviceIp = '10.66.121.85'; // ✅ PC ka IP
  static const int    _port         = 3000;

  // Auto: emulator = 10.0.2.2, real device = upar wala IP
  static String get _baseUrl {
    if (Platform.isAndroid) {
      // Emulator detect — emulator ka IP 10.0.2.2 hota hai
      // Real device pe _realDeviceIp use hoga
      return kIsWeb
          ? 'http://localhost:$_port'
          : 'http://$_realDeviceIp:$_port';
    }
    return 'http://localhost:$_port';
  }

  static final _client = http.Client();
  static const _timeout = Duration(seconds: 10);

=======
  //  🌐  BASE URL — apna IP yahan set karo
  // ══════════════════════════════════════════════════════════════════════════
  static const String _realDeviceIp = '10.66.121.85'; // ✅ PC ka IP
  static const int    _port         = 3000;

  static String get _baseUrl => 'http://$_realDeviceIp:$_port';

  static const _timeout = Duration(seconds: 10);

  // ✅ Har request pe FRESH client banao
  // Static client reuse karne se server restart ke baad stale connection
  // milti hai — isliye retry kaam nahi karta tha bina hot restart ke
  static http.Client _freshClient() => http.Client();

>>>>>>> a8d73e13878be1993fa9c727868a03adaa5afa34
  // ─── Helper ───────────────────────────────────────────────────────────────
  static List<FoodModel> _parseList(String body) {
    final json = jsonDecode(body);
    final List data = json['data'] as List;
    return data.map((e) => FoodModel.fromJson(e)).toList();
  }

  // ─── GET /foods ───────────────────────────────────────────────────────────
  static Future<List<FoodModel>> getAllFoods() async {
    debugPrint('📡 [API] GET $_baseUrl/foods');
<<<<<<< HEAD
    final res = await _client
        .get(Uri.parse('$_baseUrl/foods'))
        .timeout(_timeout);
    debugPrint('✅ [API] /foods → ${res.statusCode}');
    if (res.statusCode == 200) return _parseList(res.body);
    throw Exception('getAllFoods failed: ${res.statusCode}');
=======
    final client = _freshClient();
    try {
      final res = await client
          .get(Uri.parse('$_baseUrl/foods'))
          .timeout(_timeout);
      debugPrint('✅ [API] /foods → ${res.statusCode}');
      if (res.statusCode == 200) return _parseList(res.body);
      throw Exception('getAllFoods failed: ${res.statusCode}');
    } finally {
      client.close();
    }
>>>>>>> a8d73e13878be1993fa9c727868a03adaa5afa34
  }

  // ─── GET /foods/popular ───────────────────────────────────────────────────
  static Future<List<FoodModel>> getPopularFoods() async {
    debugPrint('📡 [API] GET $_baseUrl/foods/popular');
<<<<<<< HEAD
    final res = await _client
        .get(Uri.parse('$_baseUrl/foods/popular'))
        .timeout(_timeout);
    debugPrint('✅ [API] /foods/popular → ${res.statusCode}');
    if (res.statusCode == 200) return _parseList(res.body);
    throw Exception('getPopularFoods failed: ${res.statusCode}');
=======
    final client = _freshClient();
    try {
      final res = await client
          .get(Uri.parse('$_baseUrl/foods/popular'))
          .timeout(_timeout);
      debugPrint('✅ [API] /foods/popular → ${res.statusCode}');
      if (res.statusCode == 200) return _parseList(res.body);
      throw Exception('getPopularFoods failed: ${res.statusCode}');
    } finally {
      client.close();
    }
>>>>>>> a8d73e13878be1993fa9c727868a03adaa5afa34
  }

  // ─── GET /foods/category/:category ───────────────────────────────────────
  static Future<List<FoodModel>> getFoodsByCategory(String category) async {
    debugPrint('📡 [API] GET $_baseUrl/foods/category/$category');
<<<<<<< HEAD
    final res = await _client
        .get(Uri.parse('$_baseUrl/foods/category/$category'))
        .timeout(_timeout);
    debugPrint('✅ [API] /foods/category/$category → ${res.statusCode}');
    if (res.statusCode == 200) return _parseList(res.body);
    throw Exception('getFoodsByCategory failed: ${res.statusCode}');
=======
    final client = _freshClient();
    try {
      final res = await client
          .get(Uri.parse('$_baseUrl/foods/category/$category'))
          .timeout(_timeout);
      debugPrint('✅ [API] /foods/category/$category → ${res.statusCode}');
      if (res.statusCode == 200) return _parseList(res.body);
      throw Exception('getFoodsByCategory failed: ${res.statusCode}');
    } finally {
      client.close();
    }
>>>>>>> a8d73e13878be1993fa9c727868a03adaa5afa34
  }

  // ─── GET /foods/search?q= ─────────────────────────────────────────────────
  static Future<List<FoodModel>> searchFoods(String query) async {
    final uri = Uri.parse('$_baseUrl/foods/search')
        .replace(queryParameters: {'q': query});
    debugPrint('📡 [API] GET $uri');
<<<<<<< HEAD
    final res = await _client.get(uri).timeout(_timeout);
    debugPrint('✅ [API] /foods/search → ${res.statusCode}');
    if (res.statusCode == 200) return _parseList(res.body);
    throw Exception('searchFoods failed: ${res.statusCode}');
=======
    final client = _freshClient();
    try {
      final res = await client.get(uri).timeout(_timeout);
      debugPrint('✅ [API] /foods/search → ${res.statusCode}');
      if (res.statusCode == 200) return _parseList(res.body);
      throw Exception('searchFoods failed: ${res.statusCode}');
    } finally {
      client.close();
    }
>>>>>>> a8d73e13878be1993fa9c727868a03adaa5afa34
  }

  // ─── GET /foods/:id ───────────────────────────────────────────────────────
  static Future<FoodModel> getFoodById(String id) async {
    debugPrint('📡 [API] GET $_baseUrl/foods/$id');
<<<<<<< HEAD
    final res = await _client
        .get(Uri.parse('$_baseUrl/foods/$id'))
        .timeout(_timeout);
    debugPrint('✅ [API] /foods/$id → ${res.statusCode}');
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return FoodModel.fromJson(json['data']);
=======
    final client = _freshClient();
    try {
      final res = await client
          .get(Uri.parse('$_baseUrl/foods/$id'))
          .timeout(_timeout);
      debugPrint('✅ [API] /foods/$id → ${res.statusCode}');
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        return FoodModel.fromJson(json['data']);
      }
      throw Exception('getFoodById failed: ${res.statusCode}');
    } finally {
      client.close();
>>>>>>> a8d73e13878be1993fa9c727868a03adaa5afa34
    }
  }
}