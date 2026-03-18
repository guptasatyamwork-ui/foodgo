import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';

class AboutController extends GetxController {

  // ─── Privacy Policy Content ───────────────────────────────────────────────
  final privacyPolicySections = [
    {
      'title': 'Information We Collect',
      'content':
          'We collect information you provide directly to us, such as your name, email address, phone number, and delivery address when you create an account or place an order.',
    },
    {
      'title': 'How We Use Your Information',
      'content':
          'We use your information to process orders, send delivery updates, improve our services, and communicate with you about promotions and offers (with your consent).',
    },
    {
      'title': 'Information Sharing',
      'content':
          'We do not sell your personal data. We share your information only with delivery partners and restaurants necessary to fulfill your orders.',
    },
    {
      'title': 'Data Security',
      'content':
          'We use industry-standard encryption and security measures to protect your personal information from unauthorized access or disclosure.',
    },
    {
      'title': 'Your Rights',
      'content':
          'You have the right to access, update, or delete your personal information at any time. Contact us at privacy@foodgo.com for any requests.',
    },
    {
      'title': 'Contact Us',
      'content':
          'If you have questions about this Privacy Policy, please contact us at privacy@foodgo.com or call +1 (800) 123-4567.',
    },
  ];

  // ─── Terms of Service Content ─────────────────────────────────────────────
  final termsSections = [
    {
      'title': 'Acceptance of Terms',
      'content':
          'By using Foodgo, you agree to these Terms of Service. If you do not agree, please do not use our application.',
    },
    {
      'title': 'Use of Service',
      'content':
          'Foodgo is intended for personal, non-commercial use. You must be at least 18 years old to use our services and create an account.',
    },
    {
      'title': 'Orders & Payments',
      'content':
          'All orders are subject to availability. Prices may change without notice. Payment is processed securely at the time of order placement.',
    },
    {
      'title': 'Cancellation Policy',
      'content':
          'Orders may be cancelled within 5 minutes of placement. After this window, cancellations are subject to restaurant approval and may incur charges.',
    },
    {
      'title': 'Limitation of Liability',
      'content':
          'Foodgo is not liable for delays caused by restaurants, traffic, or weather conditions. We strive to ensure timely delivery but cannot guarantee exact times.',
    },
    {
      'title': 'Changes to Terms',
      'content':
          'We may update these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.',
    },
  ];

  // ─── Cookie Policy Content ────────────────────────────────────────────────
  final cookieSections = [
    {
      'title': 'What Are Cookies?',
      'content':
          'Cookies are small text files stored on your device that help us remember your preferences and improve your experience on Foodgo.',
    },
    {
      'title': 'Essential Cookies',
      'content':
          'These cookies are necessary for the app to function properly. They enable core features like login sessions, cart management, and security.',
    },
    {
      'title': 'Analytics Cookies',
      'content':
          'We use analytics cookies to understand how users interact with our app, helping us improve features and fix issues faster.',
    },
    {
      'title': 'Marketing Cookies',
      'content':
          'With your consent, we use marketing cookies to show you relevant promotions and personalized offers based on your preferences.',
    },
    {
      'title': 'Managing Cookies',
      'content':
          'You can control cookie preferences in your device settings. Note that disabling some cookies may affect app functionality.',
    },
    {
      'title': 'Updates to This Policy',
      'content':
          'We may update our cookie policy periodically. Any changes will be reflected in the app and on our website at foodgo.com/cookies.',
    },
  ];

  // ─── Show Privacy Policy ──────────────────────────────────────────────────
  void showPrivacyPolicy() {
    _showLegalBottomSheet(
      title: 'Privacy Policy',
      subtitle: 'Last updated: March 2026',
      icon: Icons.privacy_tip_outlined,
      color: const Color(0xFF2196F3),
      sections: privacyPolicySections,
    );
  }

  // ─── Show Terms of Service ────────────────────────────────────────────────
  void showTermsOfService() {
    _showLegalBottomSheet(
      title: 'Terms of Service',
      subtitle: 'Effective: March 2026',
      icon: Icons.article_outlined,
      color: const Color(0xFF4CAF50),
      sections: termsSections,
    );
  }

  // ─── Show Cookie Policy ───────────────────────────────────────────────────
  void showCookiePolicy() {
    _showLegalBottomSheet(
      title: 'Cookie Policy',
      subtitle: 'Last updated: March 2026',
      icon: Icons.cookie_outlined,
      color: const Color(0xFFFF9800),
      sections: cookieSections,
    );
  }

  // ─── Internal: Generic Legal Bottom Sheet ─────────────────────────────────
  void _showLegalBottomSheet({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<Map<String, String>> sections,
  }) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            const Divider(height: 24),

            // Scrollable content
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: sections.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              section['title']!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 38),
                        child: Text(
                          section['content']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Close button at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'I Understand',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}