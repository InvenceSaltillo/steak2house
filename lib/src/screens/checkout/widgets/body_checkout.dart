import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:steak2house/src/controllers/cart_controller.dart';

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
                '${_cartCtrl.cartList.length} Producto(s)',
                style: TextStyle(
                  fontSize: _utils.getHeightPercent(.02),
                ),
              ),
              CheckOutProductsCard(),
              SizedBox(height: _utils.getHeightPercent(.02)),
              ChekOutLocationCard(),
              CheckOutPaymentCard(),
              CheckOutSummaryCard(),
              // ElevatedButton(
              //   onPressed: () async {
              //     // final setApi =
              //     //     await conekta.setApiKey('key_syg4GCFA3rp7CuXnrvzn7A');
              //     // print('USER ${_userCtrl.user.value.conektaCustomerId}');
              //   },
              //   child: Icon(
              //     Icons.payment,
              //   ),
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     final card = ConektaCard(
              //       cardName: 'Alfonso Osorio',
              //       cardNumber: '4242424242424242',
              //       cvv: '847',
              //       expirationMonth: '12',
              //       expirationYear: '2040',
              //     );

              //     final String token =
              //         await PaymentService.instance.createCardToken(card);

              //     print('TOKEN $token');

              //     if (_userCtrl.user.value.conektaCustomerId == '' ||
              //         _userCtrl.user.value.conektaCustomerId == null) {
              //       print('NO TIENE CONEKTAID');
              //       PaymentService.instance.createCustomer(token);
              //     } else {}
              //   },
              //   child: Icon(
              //     Icons.payments_sharp,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
