
import 'dart:convert';

import 'package:billing_app/widgets/item_row.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/item_data.dart';
import 'models/store_data.dart';  // Import for JSON encoding/decoding

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _invoiceNumberController = TextEditingController();
  final List<Item> _items = [Item()]; // Initialize with one empty item
  final List<Store> _stores = []; // List to manage stores
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStores(); // Load stores from SharedPreferences
  }

  void _loadStores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storesString = prefs.getString('stores');
    if (storesString != null) {
      List<dynamic> storesJson = json.decode(storesString);
      setState(() {
        _stores.addAll(storesJson.map((store) => Store.fromJson(store)).toList());
      });
    }
  }

  void _saveStores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storesString = json.encode(_stores.map((store) => store.toJson()).toList());
    prefs.setString('stores', storesString);
  }

  void _addItem() {
    setState(() {
      _items.add(Item());
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _totalAmount = _items.fold(0, (sum, item) => sum + item.amount);
  }

  void _showAddStoreDialog() {
    final TextEditingController _storeNameController = TextEditingController();
    final TextEditingController _storeStreetController = TextEditingController();
    final TextEditingController _storeCityController = TextEditingController();
    final TextEditingController _storeMobileController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Store'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _storeNameController,
                decoration: InputDecoration(labelText: 'Store Name'),
              ),
              TextField(
                controller: _storeStreetController,
                decoration: InputDecoration(labelText: 'Street'),
              ),
              TextField(
                controller: _storeCityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: _storeMobileController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  Store newStore = Store(
                    name: _storeNameController.text,
                    street: _storeStreetController.text,
                    city: _storeCityController.text,
                    mobile: _storeMobileController.text,
                  );
                  _stores.add(newStore);
                  _saveStores(); // Save the new store list to SharedPreferences
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteStore(int index) {
    setState(() {
      _stores.removeAt(index); // Remove the store at the specified index
      _saveStores(); // Save the updated store list to SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _customerNameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
              ),
              TextField(
                controller: _invoiceNumberController,
                decoration: InputDecoration(labelText: 'Invoice Number'),
              ),
              SizedBox(height: 16),
              Text(
                'Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ItemRow(
                    item: _items[index],
                    onChanged: (value) {
                      setState(() {
                        _items[index] = value;
                        _calculateTotal();
                      });
                    },
                  );
                },
              ),
              ElevatedButton(
                onPressed: _addItem,
                child: Text('Add Item'),
              ),
              SizedBox(height: 16),
              Text(
                'Stores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _stores.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_stores[index].name}'),
                    subtitle: Text('${_stores[index].street}, ${_stores[index].city}\nMobile: ${_stores[index].mobile}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteStore(index),
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: _showAddStoreDialog,
                child: Text('Add Store'),
              ),
              SizedBox(height: 16),
              Text(
                'Total Amount: \$${_totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _invoiceNumberController.dispose();
    super.dispose();
  }
}
