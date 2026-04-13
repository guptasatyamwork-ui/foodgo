// lib/core/constants/api_constants.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  // ══════════════════════════════════════════════════════════════════════════
  //  🔑  CLAUDE API KEY
  //
  //  Step 1: https://console.anthropic.com → API Keys → Create Key
  //  Step 2: Neeche claudeApiKey mein paste karo
  //  ⚠️  Key ko GitHub pe push mat karna!
  // ══════════════════════════════════════════════════════════════════════════
static String get claudeApiKey => dotenv.env['CLAUDE_API_KEY'] ?? '';

  static const String claudeBaseUrl   = 'https://api.anthropic.com/v1/messages';
  static const String claudeVersion   = '2023-06-01';
  static const String claudeModel     = 'claude-haiku-4-5-20251001'; // ✅ sahi model string
  static const int    claudeMaxTokens = 10;   // sirf ek word chahiye — 10 enough hai
  static const int    timeoutSeconds  = 15;
}