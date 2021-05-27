import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/screens/checkout/widgets/delivery_time_card_checkout.dart';

import 'package:steak2house/src/utils/utils.dart';

import 'location_card_checkout.dart';
import 'products_card_checkout.dart';
import 'summary_card_checkout.dart';
import 'payment_card_checkout.dart';

class BodyCheckOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _cartCtrl = Get.find<CartController>();

    final _utils = Utils.instance;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(_utils.getWidthPercent(.02)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _cartCtrl.cartList.length == 1
                    ? '${_cartCtrl.cartList.length} producto'
                    : '${_cartCtrl.cartList.length} productos',
                style: TextStyle(
                  fontSize: _utils.getHeightPercent(.02),
                ),
              ),
              CheckOutProductsCard(),
              SizedBox(height: _utils.getHeightPercent(.02)),
              ChekOutLocationCard(),
              CheckOutPaymentCard(),
              DeliveryTimeCard(),
              CheckOutSummaryCard(),
            ],
          ),
        ),
      ),
    );
  }
}
