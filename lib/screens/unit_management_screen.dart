import 'package:flutter/material.dart';
import '../models/unit.dart';
import '../services/api_service.dart';
import 'add_unit_screen.dart';

class UnitManagementScreen extends StatefulWidget {
  @override
  _UnitManagementScreenState createState() =>
      _UnitManagementScreenState();
}

class _UnitManagementScreenState extends State<UnitManagementScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Unit> _units = [];

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    try {
      final units = await _apiService.fetchUnits();
      setState(() {
        _units = units;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading units: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Units'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateUnitScreen()),
              );
              if (result != null) {
                _loadUnits();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _units.isEmpty
              ? Center(
                  child: Text('No units found',
                      style: Theme.of(context).textTheme.bodyLarge),
                )
              : RefreshIndicator(
                  onRefresh: _loadUnits,
                  child: ListView.builder(
                    itemCount: _units.length,
                    itemBuilder: (context, index) {
                      final unit = _units[index];
                      return Dismissible(
                        key: Key(unit.unitId.toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) => _confirmDelete(unit),
                        onDismissed: (direction) => _deleteUnit(unit),
                        child: Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Text(
                              unit.unitName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Future<bool> _confirmDelete(Unit unit) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Unit'),
            content: Text(
              'Are you sure you want to delete "${unit.unitName}"? '
              'This action cannot be undone.',
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ), 
        ) ??
        false;
  }

  Future<void> _deleteUnit(Unit unit) async {
    try {
      await _apiService.deleteUnit(unit.unitId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unit deleted successfully'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Implement undo functionality if possible
              _loadUnits();
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting unit: $e')),
      );
      _loadUnits(); // Reload the list if delete failed
    }
  }
}
