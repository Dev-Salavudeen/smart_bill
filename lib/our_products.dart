import 'package:billing_app/product_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'product.dart';

class OurProductsPage extends StatefulWidget {
  @override
  _OurProductsPageState createState() => _OurProductsPageState();
}

class _OurProductsPageState extends State<OurProductsPage> {
  late Box<Product> _productBox;

  @override
  void initState() {
    super.initState();
    _initializeHiveBox();
  }

  Future<void> _initializeHiveBox() async {
    // Open the Hive box before using it
    _productBox = await Hive.openBox<Product>('products');
    setState(() {}); // Trigger rebuild after box initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
            },
          ),
        ],
      ),
      body: !_productBox.isOpen
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator if box is not ready
          : ValueListenableBuilder<Box<Product>>(
        valueListenable: _productBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          // Create a list of DataRows for the DataTable
          List<DataRow> productRows = List.generate(box.length, (index) {
            final product = box.getAt(index);
            return DataRow(
              cells: [
                DataCell(Text((index + 1).toString())), // Display product index (1-based)
                DataCell(Text(product!.name)),
                DataCell(Text('₹${product.price.toStringAsFixed(2)}')), // Display price in Rupees
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductPage(product: product),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, index);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          });

          // Display the DataTable with the products
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Product Name')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Actions')),
              ],
              rows: productRows,
            ),
          );
        },
      ),
    );
  }

  // Function to show a delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _productBox.deleteAt(index);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
