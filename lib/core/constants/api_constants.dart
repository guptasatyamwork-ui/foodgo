// lib/core/constants/api_constants.dart

class ApiConstants {
  ApiConstants._();

  static const String claudeApiKey    = 'YOUR_API_KEY_HERE'; // 👈 yahan key paste karo
  static const String claudeBaseUrl   = 'https://api.anthropic.com/v1/messages';
  static const String claudeVersion   = '2023-06-01';
  static const String claudeModel     = 'claude-haiku-4-5';
  static const int    claudeMaxTokens = 10;
  static const int    timeoutSeconds  = 15;
}