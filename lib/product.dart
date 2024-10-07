import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1) // Ensure typeId is unique
class Product extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  Product({required this.id, required this.name, required this.price});
}
