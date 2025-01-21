import 'package:flutter/material.dart';
import 'package:frist_pp/models/category.dart';
import 'package:frist_pp/services/api_service.dart';
import '../models/product.dart';
import '../models/unit.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  AddEditProductScreen({this.product});

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _salePriceController;

  final ApiService _apiService = ApiService(); // Add this line
  bool _isLoading = false; // Add this line

  // Add these variables
  List<Category> _categories = [];
  List<Unit> _units = [];
  Category? _selectedCategory;
  Unit? _selectedUnit;

   

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.productName ?? '');
    _quantityController = TextEditingController(text: widget.product?.quantity.toString() ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _salePriceController = TextEditingController(text: widget.product?.salePrice.toString() ?? '');
    _selectedCategory = widget.product?.category;
    _selectedUnit = widget.product?.unit;
    _loadCategoriesAndUnits();
  }

  // Add this method
  Future<void> _loadCategoriesAndUnits() async {
  try {
    final categories = await _apiService.fetchCategories();
    final units = await _apiService.fetchUnits();
    
    setState(() {
      _categories = categories;
      _units = units;

      if (widget.product != null) {
        // For editing: find matching category and unit from the fetched lists
        _selectedCategory = _categories.firstWhere(
          (category) => category.categoryId == widget.product!.category.categoryId,
          orElse: () => _categories.first,
        );
        _selectedUnit = _units.firstWhere(
          (unit) => unit.unitId == widget.product!.unit.unitId,
          orElse: () => _units.first,
        );
      } else {
        // For new product: select first items as default
        _selectedCategory = categories.isNotEmpty ? categories.first : null;
        _selectedUnit = units.isNotEmpty ? units.first : null;
      }
    });
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null || _selectedUnit == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select category and unit'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final updatedProduct = Product(
          id: widget.product?.id ?? '',
          productName: _nameController.text,
          quantity: int.parse(_quantityController.text),
          price: int.parse(_priceController.text),
          salePrice: int.parse(_salePriceController.text),
          category: _selectedCategory!,
          unit: _selectedUnit!,
          productId: widget.product?.productId ?? 0,
        );

        print('Product to add: ${updatedProduct.toJson()}');

        if (widget.product == null) {
          await _apiService.addProduct(updatedProduct);
        } else {
          await _apiService.updateProduct(updatedProduct);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product saved successfully')),
        );

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Add Category Dropdown
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((Category category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.categoryName),
                    );
                  }).toList(),
                  onChanged: (Category? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
                SizedBox(height: 16),
                // Add Unit Dropdown
                DropdownButtonFormField<Unit>(
                  value: _selectedUnit,
                  decoration: InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  items: _units.map((Unit unit) {
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(unit.unitName),
                    );
                  }).toList(),
                  onChanged: (Unit? newValue) {
                    setState(() {
                      _selectedUnit = newValue;
                    });
                  },
                ),
                SizedBox(height: 16),
                // ... Your existing TextFormFields ...
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _salePriceController,
                  decoration: InputDecoration(
                    labelText: 'Sale Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a sale price';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(widget.product == null ? 'Add Product' : 'Update Product'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }
}