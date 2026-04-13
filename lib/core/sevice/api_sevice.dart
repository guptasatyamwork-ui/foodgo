// lib/core/service/api_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodgo/modules/food_model.dart';
import 'package:http/http.dart' as http;

/// Custom exception for API errors — UI mein specific handling ke liye
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class ApiService {
  // ══════════════════════════════════════════════════════════════════════════
  //  🌐  BASE URL CONFIG
  //
  //  ⚡ REAL DEVICE (USB cable) use kar rahe ho — YEH KARO:
  //     Step 1: CMD mein → ipconfig → IPv4 Address copy karo
  //     Step 2: _realDeviceIp mein apna IP paste karo
  //     Step 3: Phone aur PC same WiFi pe hone chahiye
  //
  //  💻 EMULATOR use kar rahe ho?
  //     _useEmulator = true karo — baki kuch mat badlo
  // ══════════════════════════════════════════════════════════════════════════

  static const bool   _useEmulator  = false;          // ✅ Real device = false
  static const String _realDeviceIp = '10.147.73.85'; // ⚠️  APNA IP YAHAN DAALO (ipconfig se)
  static const int    _port         = 3000;

  static String get _baseUrl {
    if (kIsWeb) return 'http://localhost:$_port';
    if (Platform.isAndroid) {
      return _useEmulator
          ? 'http://10.0.2.2:$_port'
          : 'http://$_realDeviceIp:$_port';
    }
    return 'http://localhost:$_port';
  }

  static const _timeout    = Duration(seconds: 10);
  static const _maxRetries = 2;

  static http.Client _freshClient() => http.Client();

  // ─── Retryable error check ────────────────────────────────────────────────
  static bool _isRetryable(Object e) =>
      e is SocketException ||
      e is TimeoutException ||
      e is HttpException ||
      e is OSError;

  // ─── Retry wrapper ────────────────────────────────────────────────────────
  static Future<http.Response> _getWithRetry(Uri uri) async {
    int attempt = 0;
    while (true) {
      final client = _freshClient();
      try {
        debugPrint('📡 [API] GET $uri (attempt ${attempt + 1})');
        final res = await client.get(uri).timeout(_timeout);
        debugPrint('✅ [API] ${res.statusCode} ← $uri');
        return res;
      } catch (e) {
        client.close();
        if (_isRetryable(e) && attempt < _maxRetries) {
          attempt++;
          debugPrint('⚠️ [API] Retry $attempt/$_maxRetries → $e');
          await Future.delayed(Duration(seconds: attempt));
          continue;
        }
        throw ApiException(
          'Request failed after ${attempt + 1} attempt(s): $e',
        );
      } finally {
        client.close();
      }
    }
  }

  // ─── Helper ───────────────────────────────────────────────────────────────
  static List<FoodModel> _parseList(String body) {
    final json = jsonDecode(body);
    final List data = json['data'] as List;
    return data.map((e) => FoodModel.fromJson(e)).toList();
  }

  // ─── GET /foods ───────────────────────────────────────────────────────────
  static Future<List<FoodModel>> getAllFoods() async {
    final res = await _getWithRetry(Uri.parse('$_baseUrl/foods'));
    if (res.statusCode == 200) return _parseList(res.body);
    throw ApiException('getAllFoods failed', statusCode: res.statusCode);
  }

  // ─── GET /foods/popular ───────────────────────────────────────────────────
  static Future<List<FoodModel>> getPopularFoods() async {
    final res = await _getWithRetry(Uri.parse('$_baseUrl/foods/popular'));
    if (res.statusCode == 200) return _parseList(res.body);
    throw ApiException('getPopularFoods failed', statusCode: res.statusCode);
  }

  // ─── GET /foods/category/:category ───────────────────────────────────────
  static Future<List<FoodModel>> getFoodsByCategory(String category) async {
    final res = await _getWithRetry(
        Uri.parse('$_baseUrl/foods/category/$category'));
    if (res.statusCode == 200) return _parseList(res.body);
    throw ApiException('getFoodsByCategory failed', statusCode: res.statusCode);
  }

  // ─── GET /foods/search?q= ─────────────────────────────────────────────────
  static Future<List<FoodModel>> searchFoods(String query) async {
    final uri = Uri.parse('$_baseUrl/foods/search')
        .replace(queryParameters: {'q': query});
    final res = await _getWithRetry(uri);
    if (res.statusCode == 200) return _parseList(res.body);
    throw ApiException('searchFoods failed', statusCode: res.statusCode);
  }

  // ─── GET /foods/:id ───────────────────────────────────────────────────────
  static Future<FoodModel> getFoodById(String id) async {
    final res = await _getWithRetry(Uri.parse('$_baseUrl/foods/$id'));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return FoodModel.fromJson(json['data']);
    }
    throw ApiException('getFoodById failed', statusCode: res.statusCode);
  }
}