import 'package:flutter/material.dart';

import 'package:steak2house/src/utils/utils.dart';

import '../constants.dart';

// ignore: must_be_immutable
class RoundedButton extends StatelessWidget {
  RoundedButton({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.onTap,
    this.width = .35,
    this.height = .05,
  }) : super(key: key);

  final String text;
  final double fontSize;
  double width;
  double height;
  final Function() onTap;

  final _utils = Utils.instance;

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
              width: _utils.getWidthPercent(width),
              height: _utils.getHeightPercent(height),
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
