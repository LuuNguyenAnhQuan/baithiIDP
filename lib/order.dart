import 'dart:convert';

class Order {
  String item;
  String itemName;
  double price;
  String currency;
  int quantity;

  Order({required this.item, required this.itemName, required this.price, required this.currency, required this.quantity});

  // Convert từ JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      item: json['Item'],
      itemName: json['ItemName'],
      price: json['Price'].toDouble(),
      currency: json['Currency'],
      quantity: json['Quantity'],
    );
  }

  // Chuyển thành JSON
  Map<String, dynamic> toJson() {
    return {
      'Item': item,
      'ItemName': itemName,
      'Price': price,
      'Currency': currency,
      'Quantity': quantity,
    };
  }
}
