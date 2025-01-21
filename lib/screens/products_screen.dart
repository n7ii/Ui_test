import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../models/category.dart'; // Add this
import '../models/unit.dart'; // Add this
import 'add_edit_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService().fetchProducts();
  }

  // Refresh the product list
  void _refreshProducts() {
    setState(() {
      _productsFuture = ApiService().fetchProducts();
    });
  }

  // Navigate to the add/edit product screen
  void _navigateToAddEditProduct({Product? product}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(product: product),
      ),
    );

    // Refresh the product list after adding/editing
    if (result == true) {
      _refreshProducts();
    }
  }

  // Delete a product
  void _deleteProduct(String productId) async {
    try {
      await ApiService().deleteProduct(productId);
      _refreshProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add), // This is the "+" icon (Add button)
            onPressed: () => _navigateToAddEditProduct(),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          } else {
            final List<Product> products = snapshot.data as List<Product>;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(Icons.shopping_bag, color: Colors.blue),
                    ),
                    title: Text(
                      product.productName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          'Category: ${product.category.categoryName}',
                          style: TextStyle(
                            color: Colors.grey
                                .shade600, // Changed from MColors to Colors
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Unit: ${product.unit.unitName}',
                          style: TextStyle(
                            color: Colors.grey
                                .shade600, // Changed from MColors to Colors
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Category: ${product.category?.categoryName ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Unit: ${product.unit?.unitName ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Quantity: ${product.quantity}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Price: \$${product.price}',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sale Price: \$${product.salePrice}',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _navigateToAddEditProduct(product: product),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(product.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      // Add a FloatingActionButton for adding products
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _navigateToAddEditProduct(), // Navigates to the add/edit screen
        child: Icon(Icons.add), // This is the "+" icon (Add button)
        backgroundColor: Colors.blue,
      ),
    );
  }
}
