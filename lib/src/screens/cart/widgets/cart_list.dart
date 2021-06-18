import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/screens/checkout/checkout_screen.dart';
import 'package:steak2house/src/services/traffic_service.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';
import 'package:steak2house/src/widgets/rounded_button.dart';

import 'cart_product_card.dart';

class CartList extends StatelessWidget {
  CartList({
    Key? key,
  }) : super(key: key);

  final _cartCtrl = Get.find<CartController>();
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
          child: RoundedButton(
            text: 'Ir a Pagar \$${_cartCtrl.totalCart.value}',
            fontSize: .025,
            width: .7,
            onTap: () async {
              Dialogs.instance
                  .showLoadingProgress(message: 'Espere un momento...');
              final distance =
                  await TrafficService.instance.getDeliveryDistance();
              _miscCtrl.deliveryDistance.value = distance;

              Get.back();
              if (distance != -1.0) Get.to(() => CheckOutScreen());
            },
          ),
        ),
      ],
    );
  }
}
