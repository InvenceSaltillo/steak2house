import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/services/payment_service.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/payment_success.dart';

import '../constants.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final double fontSize;
  final Function() onTap;

  final _utils = Utils.instance;
  final _cartCtrl = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _utils.getHeightPercent(.07),
      decoration: BoxDecoration(
          // color: Colors.black.withOpacity(.06),
          ),
      child: Center(
        child: Material(
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: _utils.getHeightPercent(.35),
              height: _utils.getHeightPercent(.05),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  text,
                  // 'Terminar Pedido \$${(_cartCtrl.totalCart.value + (_miscCtrl.deliveryDistance.value * _miscCtrl.priceKM.value)).toStringAsFixed(2)}',
                  // 'Ir a Pagar \$${_cartCtrl.totalCart.value}',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: _utils.getHeightPercent(fontSize),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
