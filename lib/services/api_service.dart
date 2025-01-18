import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://product-management-backend-8m3e.onrender.com/api';

  // Fetch all products
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      print('Fetch Products Response Status Code: ${response.statusCode}'); // Print the status code
      print('Fetch Products Response Body: ${response.body}'); // Print the response body

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          final List<dynamic> productsJson = data['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e'); // Print the error
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Add a new product
  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'), // POST /api/products
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'product_name': product.productName,
          'quantity': product.quantity,
          'price': product.price,
          'sale_price': product.salePrice,
          'category_id': product.categoryName,
          'unit_id': product.unitName,
        }),
      );

      print('Add Product Response Status Code: ${response.statusCode}'); // Print the status code
      print('Add Product Response Body: ${response.body}'); // Print the response body

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          // Product added successfully
          print('Product added successfully: ${data['message']}');
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to add product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding product: $e'); // Print the error
      throw Exception('Failed to add product: $e');
    }
  }

  // Update an existing product
  Future<void> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/${product.id}'), // PUT /api/products/:id
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'product_name': product.productName,
          'quantity': product.quantity,
          'price': product.price,
          'sale_price': product.salePrice,
          'category_id': product.categoryName,
          'unit_id': product.unitName,
        }),
      );

      print('Update Product Response Status Code: ${response.statusCode}'); // Print the status code
      print('Update Product Response Body: ${response.body}'); // Print the response body

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          // Product updated successfully
          print('Product updated successfully: ${data['message']}');
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to update product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating product: $e'); // Print the error
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete a product
Future<void> deleteProduct(String productId) async {
  try {
    // Construct the URL with product_id as a path parameter
    final url = Uri.parse('$baseUrl/products/$productId');

    print('$productId');


    // Make the DELETE request with body
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        print('Product deleted successfully: ${data['message']}');
      } else {
        throw Exception('API Error: ${data['message']}');
      }
    } else {
      throw Exception('Failed to delete product. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting product: $e');
    throw Exception('Failed to delete product: $e');
  }
}

}