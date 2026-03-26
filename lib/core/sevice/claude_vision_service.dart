// lib/core/sevice/claude_vision_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class ClaudeVisionService {
  ClaudeVisionService._();
  static final ClaudeVisionService instance = ClaudeVisionService._();

  static const List<String> validCategories = [
    'Burgers', 'Pizza', 'Drinks', 'Combos',
  ];

  /// Returns category string ya null (API off / error / not food)
  Future<String?> detectFoodCategory(String base64Image) async {
    // Key check
    if (ApiConstants.claudeApiKey.isEmpty ||
        ApiConstants.claudeApiKey == 'YOUR_API_KEY_HERE') {
      debugPrint('🔑 [Claude] API key not set → null');
      return null;
    }

    debugPrint('📡 [Claude] Sending request...');

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.claudeBaseUrl),
        headers: {
          'Content-Type':      'application/json',
          'x-api-key':         ApiConstants.claudeApiKey,
          'anthropic-version': ApiConstants.claudeVersion,
        },
        body: jsonEncode({
          'model':      ApiConstants.claudeModel,
          'max_tokens': ApiConstants.claudeMaxTokens,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type':   'image',
                  'source': {
                    'type':       'base64',
                    'media_type': 'image/jpeg',
                    'data':       base64Image,
                  },
                },
                {
                  'type': 'text',
                  'text': 'Look at this food image. Reply with ONE word only:\n'
                      'Burgers / Pizza / Drinks / Combos / Unknown\n\n'
                      '- Burgers = burger, sandwich, patty\n'
                      '- Pizza   = pizza, flatbread\n'
                      '- Drinks  = any drink, juice, smoothie, coffee\n'
                      '- Combos  = combo meal, fried chicken, fries, platter\n'
                      '- Unknown = not food\n\n'
                      'ONE word only. No explanation.',
                },
              ],
            },
          ],
        }),
      ).timeout(const Duration(seconds: ApiConstants.timeoutSeconds));

      // ── Status log — Logcat mein dikhega ────────────────────────────
      debugPrint('✅ [Claude] Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint('❌ [Claude] Error body: ${response.body}');
        return null;
      }

      final raw =
          (jsonDecode(response.body)['content'][0]['text'] as String).trim();

      debugPrint('🍔 [Claude] Response: "$raw"');

      for (final cat in validCategories) {
        if (raw.toLowerCase().contains(cat.toLowerCase())) {
          debugPrint('🎯 [Claude] Matched category: $cat');
          return cat;
        }
      }

      debugPrint('⚠️ [Claude] No category matched → null');
      return null;
    } catch (e) {
      debugPrint('💥 [Claude] Exception: $e');
      return null;
    }
  }
}