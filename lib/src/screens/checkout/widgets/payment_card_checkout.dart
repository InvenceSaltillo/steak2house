import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/screens/credit_card/credit_card_screen.dart';
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
                  : getBrandIcon(_paymentCtrl.lastUsedCard.value.brand!),
              SizedBox(width: _utils.getWidthPercent(.05)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _paymentCtrl.lastUsedCard.value.id == null
                        ? 'No hay método de pago'
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

  Widget getBrandIcon(String brand) {
    switch (brand) {
      case 'visa':
        return FaIcon(FontAwesomeIcons.ccVisa, color: kPrimaryColor);
      case 'mastercard':
        return FaIcon(FontAwesomeIcons.ccMastercard, color: kPrimaryColor);
      case 'american_express':
        return FaIcon(FontAwesomeIcons.ccAmex, color: kPrimaryColor);
      default:
        return FaIcon(FontAwesomeIcons.creditCard, color: kPrimaryColor);
    }
  }
}
