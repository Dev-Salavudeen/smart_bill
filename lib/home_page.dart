import 'package:billing_app/product_page.dart';
import 'package:flutter/material.dart';

import 'billing_page.dart';
import 'our_products.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildCard(context, 'Our Products', Icons.list, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OurProductsPage()),
            );
          }),
          _buildCard(context, 'Add Products', Icons.add, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductPage()),
            );
          }),
          _buildCard(context, 'Billing', Icons.attach_money, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BillingPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical spacing
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Added padding inside the card
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue), // Adjust icon size and color
              SizedBox(height: 8), // Spacing between icon and text
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
