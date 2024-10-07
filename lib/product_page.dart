import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'product.dart';

class AddProductPage extends StatefulWidget {
  final Product? product; // Pass a Product object if editing

  AddProductPage({this.product});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final box = await Hive.openBox<Product>('products');
      final name = _nameController.text;
      final price = double.parse(_priceController.text);

      if (widget.product == null) {
        // Adding new product
        final product = Product(id: box.length + 1, name: name, price: price);
        await box.add(product); // Add the product with an auto-generated key
      } else {
        // Editing existing product
        final updatedProduct = Product(id: widget.product!.id, name: name, price: price);
        widget.product!.name = name;
        widget.product!.price = price;
        await widget.product!.save(); // Update the product using HiveObject's save method
      }

      Navigator.pop(context); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
