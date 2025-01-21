import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://product-management-backend-8m3e.onrender.com/api';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> productsJson = data['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load products');
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$productId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}