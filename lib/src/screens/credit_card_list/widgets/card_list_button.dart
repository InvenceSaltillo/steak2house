import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/screens/credit_card/credit_card_screen.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../../../constants.dart';

class CardListButton extends StatelessWidget {
  CardListButton({
    Key? key,
  }) : super(key: key);

  final _paymentCtrl = Get.find<PaymentController>();
  final _utils = Utils.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {
            if (_paymentCtrl.cardSelectedIdx < _paymentCtrl.cardsList.length) {
              _paymentCtrl.lastUsedCard.value =
                  _paymentCtrl.cardsList[_paymentCtrl.cardSelectedIdx.value];
              Get.back();
            } else {
              Get.back();
              Get.to(() => CreditCardScreen());
            }
          },
          child: Container(
            width: _utils.getHeightPercent(.25),
            height: _utils.getHeightPercent(.05),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                _paymentCtrl.cardSelectedIdx < _paymentCtrl.cardsList.length
                    ? 'Aceptar'
                    : 'Agregar',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: _utils.getHeightPercent(.02),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
