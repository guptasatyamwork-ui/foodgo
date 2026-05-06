class ApiConstants {
  ApiConstants._();

  // ⚠️ GitHub pe push mat karna
  static const String claudeApiKey =
      'YOUR_CLAUDE_API_KEY';

  static const String claudeBaseUrl   =
      'https://api.anthropic.com/v1/messages';

  static const String claudeVersion   = '2023-06-01';

  // ✅ Valid model
  static const String claudeModel =
      'claude-3-haiku-20240307';

  static const int claudeMaxTokens = 100;

  static const int timeoutSeconds = 15;
}