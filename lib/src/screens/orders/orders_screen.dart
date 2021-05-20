import 'package:flutter/material.dart';

import 'widgets/body_orders.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = "/orders";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: BodyOrders(),
      ),
    );
  }
}
