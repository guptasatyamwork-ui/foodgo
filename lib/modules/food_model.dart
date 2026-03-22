class FoodModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int    reviewCount;
  final String imageUrl;
  final String category;
  final bool   isPopular;
  final bool   isVeg;
  final int    calories;
  final String prepTime;

  const FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.category,
    required this.isPopular,
    required this.isVeg,
    required this.calories,
    required this.prepTime,
  });

  // ✅ API response (server.js) se FoodModel banao
  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id:          json['id']?.toString()          ?? '',
      name:        json['name']?.toString()        ?? '',
      description: json['description']?.toString() ?? '',
      price:       (json['price']  as num?)?.toDouble() ?? 0.0,
      rating:      (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      imageUrl:    json['imageUrl']?.toString()    ?? '',
      category:    json['category']?.toString()    ?? '',
      isPopular:   json['isPopular']  as bool?     ?? false,
      isVeg:       json['isVeg']      as bool?     ?? false,
      calories:    (json['calories'] as num?)?.toInt() ?? 0,
      prepTime:    json['prepTime']?.toString()    ?? '',
    );
  }
}