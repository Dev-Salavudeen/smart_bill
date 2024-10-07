// item_row.dart
import 'package:flutter/material.dart';

import '../models/item_data.dart';

class ItemRow extends StatefulWidget {
  final Item item;
  final ValueChanged<Item> onChanged;

  const ItemRow({required this.item, required this.onChanged, Key? key}) : super(key: key);

  @override
  _ItemRowState createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(text: widget.item.quantity.toString());
    _priceController = TextEditingController(text: widget.item.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateItem() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final amount = price * quantity;

    widget.onChanged(Item(name: name, quantity: quantity, price: price)..amount = amount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _updateItem(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _updateItem(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _updateItem(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: widget.item.amount.toStringAsFixed(2)),
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
