import 'package:get/get.dart';
import '../../{core,modules,widgets,routes,models,services}/models/food_model.dart';
import '../../services/food_service.dart';

class ProfileController extends GetxController {
  final RxString name = 'Alex Johnson'.obs;
  final RxString email = 'alex.johnson@email.com'.obs;
  final RxString address = '123 Main Street, New York, NY 10001'.obs;
  final RxString phone = '+1 (555) 123-4567'.obs;

  final List<Map<String, dynamic>> orderHistory = [
    {
      'id': '#FG2401',
      'date': 'Mar 5, 2026',
      'items': 3,
      'total': 42.97,
      'status': 'Delivered',
    },
    {
      'id': '#FG2389',
      'date': 'Mar 3, 2026',
      'items': 2,
      'total': 27.98,
      'status': 'Delivered',
    },
    {
      'id': '#FG2374',
      'date': 'Feb 28, 2026',
      'items': 5,
      'total': 68.45,
      'status': 'Delivered',
    },
  ];

  void logout() {
    Get.dialog(
      _buildLogoutDialog(),
    );
  }

  dynamic _buildLogoutDialog() {
    return null; // handled in view
  }

  void confirmLogout() {
    Get.offAllNamed('/splash');
  }
}
