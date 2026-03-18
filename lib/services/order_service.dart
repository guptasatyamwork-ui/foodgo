import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OrderModel {
  final String id;
  final String date;
  final int itemCount;
  final double total;
  final String status;
  final List<Map<String, dynamic>> items;

  OrderModel({
    required this.id,
    required this.date,
    required this.itemCount,
    required this.total,
    required this.status,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'itemCount': itemCount,
    'total': total,
    'status': status,
    'items': items,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'],
    date: json['date'],
    itemCount: json['itemCount'],
    total: json['total'],
    status: json['status'],
    items: List<Map<String, dynamic>>.from(json['items']),
  );
}

class OrderService extends GetxService {
  static const String _keyOrders = 'order_history';

  final RxList<OrderModel> orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyOrders);
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      orders.value = decoded.map((e) => OrderModel.fromJson(e)).toList();
    }
  }

  Future<void> saveOrder(OrderModel order) async {
    orders.insert(0, order); // ✅ Latest pehle
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOrders, jsonEncode(orders.map((o) => o.toJson()).toList()));
  }

  // Unique order ID generate karo
  String generateOrderId() {
    final now = DateTime.now();
    return '#FG${now.year % 100}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecond}';
  }

  // Date format
  String formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}