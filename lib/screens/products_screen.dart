import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'add_edit_product_screen.dart';
import 'product_details_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> _productsFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = ApiService().fetchProducts().then((products) {
        _allProducts = products;
        _filteredProducts = products;
        return products;
      });
    });
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        return product.productName.toLowerCase().contains(query) ||
            product.category.categoryName.toLowerCase().contains(query) ||
            product.unit.unitName.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _navigateToAddEditProduct({Product? product}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(product: product),
      ),
    );
    if (result == true) {
      _loadProducts();
    }
  }

  void _deleteProduct(String productId) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ApiService().deleteProduct(productId);
        _loadProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete product: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToAddEditProduct(),
            tooltip: 'Add Product',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterProducts();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _loadProducts();
              },
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerLoading();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${snapshot.error}'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadProducts,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No products found', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    );
                  }

                  final products = _searchController.text.isEmpty
                      ? _allProducts
                      : _filteredProducts;

                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(product);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditProduct(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        tooltip: 'Add Product',
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToProductDetails(product),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image (replace with actual image URL if available)
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue.shade100,
                ),
                child: Center(
                  child: Icon(Icons.shopping_bag, size: 64, color: Colors.blue),
                ),
              ),
              SizedBox(height: 12),
              Text(
                product.productName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                'Category: ${product.category.categoryName}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Price: \$' + product.price.toString(),
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _navigateToAddEditProduct(product: product),
                    tooltip: 'Edit Product',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteProduct(product.productId.toString()),
                    tooltip: 'Delete Product',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 80,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 60,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}