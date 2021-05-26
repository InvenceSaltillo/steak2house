import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/screens/credit_cards/credit_card/credit_card_screen.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

import '../../../constants.dart';

class CheckOutPaymentCard extends StatelessWidget {
  CheckOutPaymentCard({
    Key? key,
  }) : super(key: key);

  final _utils = Utils.instance;
  final _paymentCtrl = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10,
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _paymentCtrl.lastUsedCard.value.id == null
                  ? FaIcon(FontAwesomeIcons.creditCard, color: kPrimaryColor)
                  : _utils.getCardBrandIcon(
                      _paymentCtrl.lastUsedCard.value.brand!, kPrimaryColor),
              SizedBox(width: _utils.getWidthPercent(.05)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _paymentCtrl.lastUsedCard.value.id == null
                        ? 'No hay tarjetas guardadas'
                        : 'Terminación  ****${_paymentCtrl.lastUsedCard.value.last4}',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.02),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  _paymentCtrl.lastUsedCard.value.id == null
                      ? Get.to(() => CreditCardScreen())
                      : Dialogs.instance.showCardsBottomSheet();
                },
                child: Text(
                  _paymentCtrl.lastUsedCard.value.id == null
                      ? 'Agregar'
                      : 'Cambiar',
                  style: TextStyle(
                    fontSize: _utils.getHeightPercent(.02),
                    color: kSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
