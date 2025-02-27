import 'dart:convert';
import 'package:flutter/material.dart';
import 'order.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrdersPage(),
    );
  }
}

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  // Đọc JSON và load vào danh sách
  void loadOrders() {
    String jsonString = '[{"Item": "A1000","ItemName": "Iphone 15","Price": 1200,"Currency": "USD","Quantity":1},{"Item": "A1001","ItemName": "Iphone 16","Price": 1500,"Currency": "USD","Quantity":1}]';
    List<dynamic> jsonData = jsonDecode(jsonString);
    orders = jsonData.map((item) => Order.fromJson(item)).toList();
    setState(() {});
  }

  // Thêm đơn hàng
  void addOrder(Order order) {
    setState(() {
      orders.add(order);
    });
  }

  // Tìm kiếm đơn hàng
  List<Order> searchOrders(String query) {
    return orders.where((order) => order.itemName.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    TextEditingController itemController = TextEditingController();
    TextEditingController itemNameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController currencyController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Order Management")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Ô nhập tìm kiếm
            TextField(
              controller: searchController,
              decoration: InputDecoration(labelText: "Tìm kiếm theo ItemName"),
              onChanged: (query) {
                setState(() {
                  orders = searchOrders(query);
                });
              },
            ),
            SizedBox(height: 10),
            // Bảng hiển thị đơn hàng
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text("${order.itemName} - ${order.currency} ${order.price}"),
                    subtitle: Text("Số lượng: ${order.quantity}"),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            // Form nhập đơn hàng mới
            TextField(controller: itemController, decoration: InputDecoration(labelText: "Mã hàng")),
            TextField(controller: itemNameController, decoration: InputDecoration(labelText: "Tên sản phẩm")),
            TextField(controller: priceController, decoration: InputDecoration(labelText: "Giá")),
            TextField(controller: currencyController, decoration: InputDecoration(labelText: "Tiền tệ")),
            TextField(controller: quantityController, decoration: InputDecoration(labelText: "Số lượng")),
            ElevatedButton(
              onPressed: () {
                Order newOrder = Order(
                  item: itemController.text,
                  itemName: itemNameController.text,
                  price: double.parse(priceController.text),
                  currency: currencyController.text,
                  quantity: int.parse(quantityController.text),
                );
                addOrder(newOrder);
              },
              child: Text("Thêm đơn hàng"),
            ),
          ],
        ),
      ),
    );
  }
}
