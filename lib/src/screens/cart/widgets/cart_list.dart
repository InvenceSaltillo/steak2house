import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/services/traffic_service.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../../../constants.dart';
import 'cart_product_card.dart';

class CartList extends StatelessWidget {
  CartList({
    Key? key,
  }) : super(key: key);

  final _cartCtrl = Get.find<CartController>();
  final _bottomNavCtrl = Get.find<BottomNavigationBarController>();
  final _miscCtrl = Get.find<MiscController>();
  final _utils = Utils.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: _utils.getHeightPercent(.01)),
        Padding(
          padding: EdgeInsets.only(
            left: _utils.getWidthPercent(.05),
            right: _utils.getWidthPercent(.05),
          ),
          child: Text(
            _cartCtrl.cartList.length == 1
                ? '${_cartCtrl.cartList.length} producto agregado'
                : '${_cartCtrl.cartList.length} producto(s) agregado(s)',
            style: TextStyle(fontSize: _utils.getWidthPercent(.05)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _cartCtrl.cartList.length,
            itemBuilder: (_, idx) {
              final cartItem = _cartCtrl.cartList[idx];
              return Padding(
                padding: EdgeInsets.only(
                  left: _utils.getWidthPercent(.05),
                  right: _utils.getWidthPercent(.05),
                ),
                child: CartProductCard(cartItem: cartItem),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () async {
              final distance =
                  await TrafficService.instance.getDeliveryDistance();
              _miscCtrl.deliveryDistance.value = distance;
              _miscCtrl.showAppBar.value = false;
              _bottomNavCtrl.pageCtrl.value.jumpToPage(5);
            },
            style: TextButton.styleFrom(
              minimumSize: Size(_utils.getWidthPercent(.7), 20),
              backgroundColor: kPrimaryColor,
              padding: EdgeInsets.all(_utils.getHeightPercent(.01)),
            ),
            child: Text(
              'Ir a Pagar \$${_cartCtrl.totalCart.value}',
              style: TextStyle(
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: _utils.getHeightPercent(.02),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
