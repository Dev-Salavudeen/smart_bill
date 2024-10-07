// store.dart
class Store {
  String name;
  String street;
  String city;
  String mobile;

  Store({this.name = '', this.street = '', this.city = '', this.mobile = ''});

  // Method to convert Store to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'street': street,
      'city': city,
      'mobile': mobile,
    };
  }

  // Method to create Store from JSON
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'],
      street: json['street'],
      city: json['city'],
      mobile: json['mobile'],
    );
  }
}
