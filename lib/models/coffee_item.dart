class CoffeeItem {
  final int? id;
  final String imageUrl;
  final String name;
  final String type;
  final double price;
  final double rating;

  CoffeeItem({
    this.id,
    required this.imageUrl,
    required this.name,
    required this.type,
    required this.price,
    required this.rating,
  });

  // Factory constructor to create CoffeeItem from JSON
  factory CoffeeItem.fromJson(Map<String, dynamic> json) {
    return CoffeeItem(
      id: json['id'] as int?,
      imageUrl: json['image_url'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['coffee_type'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Convert CoffeeItem to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'image_url': imageUrl,
      'name': name,
      'coffee_type': type,
      'price': price,
      'rating': rating,
    };
  }
}
