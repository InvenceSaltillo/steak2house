import 'package:flutter/material.dart';
import 'package:steak2house/src/screens/cart/widgets/body_cart_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: BodyCart(),
      ),
    );
  }
}
