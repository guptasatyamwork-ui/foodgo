class FoodModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String category;
  final bool isPopular;
  final bool isVeg;
  final int calories;
  final String prepTime;

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.category,
    this.isPopular = false,
    this.isVeg = false,
    this.calories = 0,
    this.prepTime = '20 min',
  });
}

class CartItem {
  final FoodModel food;
  int quantity;
  int spicyLevel;

  CartItem({
    required this.food,
    this.quantity = 1,
    this.spicyLevel = 1,
  });

  double get totalPrice => food.price * quantity;
}

class OrderHistoryModel {
  final String orderId;
  final String date;
  final List<CartItem> items;
  final double totalAmount;
  final String status;

  OrderHistoryModel({
    required this.orderId,
    required this.date,
    required this.items,
    required this.totalAmount,
    required this.status,
  });
}
