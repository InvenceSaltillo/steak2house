import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/models/conekta/payment_sources_model.dart';
import 'package:steak2house/src/services/payment_service.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';
import 'package:steak2house/src/widgets/rounded_button.dart';

import '../../../../constants.dart';

class MyCreditCardDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConecktaPaymentSource _card = Get.arguments[0];
    final int _cardIdx = Get.arguments[1];
    final _utils = Utils.instance;

    final _paymentCtrl = Get.find<PaymentController>();

    print('CARD $_cardIdx');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor),
        ),
        title: Text(
          'Tarjetas guardadas',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          CreditCardWidget(
            cardBgColor: kPrimaryColor,
            width: _utils.getWidthPercent(.9),
            cardHolderName: _card.name!,
            cardNumber: '**** **** **** ${_card.last4!}',
            cvvCode: '',
            expiryDate: '${_card.expMonth}/${_card.expYear}',
            showBackView: false,
            cardType: _getCardType(_card.brand!),
            obscureCardNumber: false,
          ),
        ],
      ),
      bottomNavigationBar: RoundedButton(
        text: 'Eliminar tarjeta',
        fontSize: .022,
        onTap: () async {
          // _paymentCtrl.cardsList.removeAt(4);
          // SharedPrefs.instance.setKey(
          //   'cardList',
          //   json.encode(_paymentCtrl.cardsList),
          // );
          final deleteResult = await Dialogs.instance.showLottieDialog(
            title: '¿Estás seguro de eliminar esta tarjeta?',
            lottieSrc: 'assets/animations/delete.json',
            firstButtonText: 'Eliminar',
            secondButtonText: 'Cancelar',
            firstButtonBgColor: Colors.red,
            secondButtonBgColor: Colors.transparent,
            firstButtonTextColor: Colors.white,
            secondButtonTextColor: Colors.black54,
          );

          if (deleteResult) {
            final delete =
                await PaymentService.instance.deletePaymentSource(_card.id!);

            if (delete) {
              _paymentCtrl.cardsList.removeAt(_cardIdx);

              Get.back();
            }
          }
        },
      ),
    );
  }

  CardType _getCardType(String brand) {
    switch (brand) {
      case 'visa':
        return CardType.visa;
      case 'mastercard':
        return CardType.mastercard;
      case 'american_express':
        return CardType.americanExpress;
      default:
        return CardType.otherBrand;
    }
  }
}
