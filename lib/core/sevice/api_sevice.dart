// lib/core/sevice/api_sevice.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodgo/modules/food_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ══════════════════════════════════════════════════════════════════════════
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

  // ─── Helper ───────────────────────────────────────────────────────────────
  static List<FoodModel> _parseList(String body) {
    final json = jsonDecode(body);
    final List data = json['data'] as List;
    return data.map((e) => FoodModel.fromJson(e)).toList();
  }

  // ─── GET /foods ───────────────────────────────────────────────────────────
  static Future<List<FoodModel>> getAllFoods() async {
    debugPrint('📡 [API] GET $_baseUrl/foods');
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
  }

  // ─── GET /foods/popular ───────────────────────────────────────────────────
  static Future<List<FoodModel>> getPopularFoods() async {
    debugPrint('📡 [API] GET $_baseUrl/foods/popular');
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
  }

  // ─── GET /foods/category/:category ───────────────────────────────────────
  static Future<List<FoodModel>> getFoodsByCategory(String category) async {
    debugPrint('📡 [API] GET $_baseUrl/foods/category/$category');
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
  }

  // ─── GET /foods/search?q= ─────────────────────────────────────────────────
  static Future<List<FoodModel>> searchFoods(String query) async {
    final uri = Uri.parse('$_baseUrl/foods/search')
        .replace(queryParameters: {'q': query});
    debugPrint('📡 [API] GET $uri');
    final client = _freshClient();
    try {
      final res = await client.get(uri).timeout(_timeout);
      debugPrint('✅ [API] /foods/search → ${res.statusCode}');
      if (res.statusCode == 200) return _parseList(res.body);
      throw Exception('searchFoods failed: ${res.statusCode}');
    } finally {
      client.close();
    }
  }

  // ─── GET /foods/:id ───────────────────────────────────────────────────────
  static Future<FoodModel> getFoodById(String id) async {
    debugPrint('📡 [API] GET $_baseUrl/foods/$id');
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
    }
  }
}