import 'category.dart';
import 'unit.dart';

class Product {
  final String id;
  final String productName;
  final int quantity;
  final int price;
  final int salePrice;
  final Category category;  // Changed from String categoryName
  final Unit unit;         // Changed from String unitName
  final int productId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.salePrice,
    required this.category,
    required this.unit,
    required this.productId,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
      salePrice: json['sale_price'] ?? 0,
      category: Category.fromJson(json['category'] ?? {}),  // Parse nested category
      unit: Unit.fromJson(json['unit'] ?? {}),             // Parse nested unit
      productId: json['product_id'] ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'sale_price': salePrice,
      'category_id': category.categoryId,
      'unit_id': unit.unitId,
    };
  }
}