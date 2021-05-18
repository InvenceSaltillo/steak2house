import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';

import 'cart_list.dart';
import 'empty_cart.dart';

class BodyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _cartCtrl = Get.find<CartController>();
    _cartCtrl.totalCart.value = 0;
    _cartCtrl.updateTotal();

    return Obx(
      () => _cartCtrl.cartList.length == 0 ? EmptyCart() : CartList(),
    );
  }
}
