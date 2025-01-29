import 'package:flutter/material.dart';

import '../services/api_service.dart';

class CreateUnitScreen extends StatefulWidget {
  @override
  _CreateUnitScreenState createState() => _CreateUnitScreenState();
}

class _CreateUnitScreenState extends State<CreateUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Unit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Unit Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveUnit,
                child: Text('Save Unit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveUnit() async {
    if (_formKey.currentState!.validate()) {
      final unitName = _nameController.text;

      // Save the new unit via API
      try {
        final newUnit = await ApiService().createUnit(unitName);

        // Return the new unit to the previous screen
        Navigator.pop(context, newUnit);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating unit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}