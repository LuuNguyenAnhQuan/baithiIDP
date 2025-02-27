import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Order {
  String item;
  String itemName;
  double price;
  String currency;
  int quantity;

  Order({
    required this.item,
    required this.itemName,
    required this.price,
    required this.currency,
    required this.quantity,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      item: json['Item'] as String,
      itemName: json['ItemName'] as String,
      price: (json['Price'] as num).toDouble(),
      currency: json['Currency'] as String,
      quantity: json['Quantity'] as int,
    );
  }

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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Order> orders = [];
  final TextEditingController itemController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    String jsonString = '[{"Item": "A1000","ItemName": "Iphone 15","Price": 1200,"Currency": "USD","Quantity":1},'
        '{"Item": "A1001","ItemName": "Iphone 16","Price": 1500,"Currency": "USD","Quantity":1}]';

    var decodedData = json.decode(jsonString);
    print(decodedData.runtimeType);

    if (decodedData is List) {
      setState(() {
        orders = decodedData.map((e) => Order.fromJson(e)).toList();
      });
    } else {
      print("Dữ liệu không phải là danh sách JSON hợp lệ.");
    }
  }

  void _addOrder() {
    setState(() {
      orders.add(Order(
        item: itemController.text,
        itemName: itemNameController.text,
        price: double.tryParse(priceController.text) ?? 0.0,
        currency: "USD",
        quantity: int.tryParse(quantityController.text) ?? 1,
      ));
      itemController.clear();
      itemNameController.clear();
      priceController.clear();
      quantityController.clear();
    });
  }

  void _deleteOrder(int index) {
    setState(() {
      orders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('My Order'), backgroundColor: Colors.orange),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("My Order", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: TextField(controller: itemController, decoration: InputDecoration(labelText: 'Item'))),
                  Expanded(child: TextField(controller: itemNameController, decoration: InputDecoration(labelText: 'Item Name'))),
                  Expanded(child: TextField(controller: priceController, decoration: InputDecoration(labelText: 'Price'))),
                  Expanded(child: TextField(controller: quantityController, decoration: InputDecoration(labelText: 'Quantity'))),
                  Expanded(child: TextField(decoration: InputDecoration(labelText: 'Currency'), enabled: false, controller: TextEditingController(text: "USD"))),
                  ElevatedButton(
                    onPressed: _addOrder,
                    child: Text('Add Item to Cart'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text("Id")),
                      DataColumn(label: Text("Item")),
                      DataColumn(label: Text("Item Name")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Price")),
                      DataColumn(label: Text("Currency")),
                      DataColumn(label: Text("Delete")),
                    ],
                    rows: orders.asMap().entries.map((entry) {
                      int index = entry.key;
                      Order order = entry.value;
                      return DataRow(cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(order.item)),
                        DataCell(Text(order.itemName)),
                        DataCell(Text(order.quantity.toString())),
                        DataCell(Text(order.price.toString())),
                        DataCell(Text(order.currency)),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteOrder(index),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text("Số 8, Tôn Thất Thuyết, Cầu Giấy, Hà Nội", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
            ],
          ),
        ),
        backgroundColor: Colors.orange.shade50,
      ),
    );
  }
}
