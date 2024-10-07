import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_page.dart';
import 'product.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());
    await Hive.openBox<Product>('products');
  } catch (e) {
    print("Error initializing Hive: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Bill',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
