class Product {
  final String id;
  final String productName;
  final int quantity;
  final int price;
  final int salePrice;
  final String categoryName;
  final String unitName;
  final int productId;

  Product({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.salePrice,
    required this.categoryName,
    required this.unitName,
    required this.productId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'],
      salePrice: json['sale_price'],
      categoryName: json['category_id']['category_name'],
      unitName: json['unit_id']['unit_name'],
      productId: json['product_id'],
    );
  }
}