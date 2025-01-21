// models/category.dart
class Category {
  final String id;
  final String categoryName;
  final int categoryId;

  Category({
    required this.id,
    required this.categoryName,
    required this.categoryId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      categoryId: json['category_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category_name': categoryName,
      'category_id': categoryId,
    };
  }
}