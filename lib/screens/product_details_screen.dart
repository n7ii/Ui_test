import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍລະອຽດສິນຄ້າ', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Placeholder
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_bag,
                    size: 50,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Product Name
              Text(
                product.productName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              // Product Details
              _buildDetailSection(
                context,
                title: 'ຂໍ້ມູນສິນຄ້າ',
                details: [
                  _buildDetailItem('Category', product.category.categoryName),
                  _buildDetailItem('Unit', product.unit.unitName),
                  _buildDetailItem('Quantity', product.quantity.toString()),
                ],
              ),
              SizedBox(height: 16),

              // Price Information
              _buildDetailSection(
                context,
                title: 'ລາຄາ',
                details: [
                  _buildDetailItem('Price', '\LAK' + product.price.toString(), color: Colors.green.shade700),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a detail section
  Widget _buildDetailSection(BuildContext context, {required String title, required List<Widget> details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: details,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build a detail item
  Widget _buildDetailItem(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}