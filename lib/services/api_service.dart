import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/product.dart';
import '../models/unit.dart';

class ApiService {
  static const String baseUrl =
      'https://product-management-backend-8m3e.onrender.com/api';

  // Fetch all products
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

  // Fetch all categories
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> categoriesJson = data['data'];
          return categoriesJson.map((json) => Category.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load categories');
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Fetch all units
  Future<List<Unit>> fetchUnits() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/units'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> unitsJson = data['data'];
          return unitsJson.map((json) => Unit.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load units');
    } catch (e) {
      throw Exception('Failed to fetch units: $e');
    }
  }

  // Add a new product
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

  // Update an existing product
  Future<void> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/${product.productId}'),
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

  // Delete a product
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

  // Create a new category
  Future<Category> createCategory(String categoryName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'category_name': categoryName}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Category.fromJson(data['data']);
        }
      }
      throw Exception('Failed to create category');
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  // Create a new unit
  Future<Unit> createUnit(String unitName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/units'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'unit_name': unitName}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Unit.fromJson(data['data']);
        }
      }
      throw Exception('Failed to create unit');
    } catch (e) {
      throw Exception('Failed to create unit: $e');
    }
  }

  // detete category
  Future<void> deleteCategory(int categoryId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$categoryId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete category');
      }
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // delete unit
  Future<void> deleteUnit(int unitId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/units/$unitId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete unit');
      }
    } catch (e) {
      throw Exception('Failed to delete unit: $e');
    }
  }
}
