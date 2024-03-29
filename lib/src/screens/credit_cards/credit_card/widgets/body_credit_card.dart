import 'package:conekta_flutter/conekta_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/services/payment_service.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

class BodyCreditCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BodyCreditCardState();
}

class BodyCreditCardState extends State<BodyCreditCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _userCtrl = Get.find<UserController>();
  final _utils = Utils.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          CreditCardWidget(
            height: _utils.getHeightPercent(.28),
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            obscureCardNumber: true,
            obscureCardCvv: true,
            labelCardHolder: 'Nombre',
            labelExpiredDate: 'MM/AA',
            cardBgColor: kPrimaryColor,
            onCreditCardWidgetChange: (CreditCardBrand) {},
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardForm(
                    formKey: formKey,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    themeColor: kPrimaryColor,
                    cursorColor: kPrimaryColor,
                    numberValidationMessage:
                        'Por favor, ingrese un número válido',
                    cardNumberDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Número',
                      hintText: 'XXXX XXXX XXXX XXXX',
                    ),
                    dateValidationMessage: 'Ingrese una fecha válida',
                    expiryDateDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fecha expiración',
                      hintText: 'MM/AA',
                    ),
                    cvvValidationMessage: 'ingrese un número válido',
                    cvvCodeDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    cardHolderDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre',
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      primary: kPrimaryColor,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontFamily: 'halter',
                          fontSize: 14,
                          package: 'flutter_credit_card',
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final expirationMonth = expiryDate.split('/')[0];
                        final expirationYear = expiryDate.split('/')[1];
                        final card = ConektaCard(
                          cardName: cardHolderName,
                          cardNumber: cardNumber,
                          cvv: cvvCode,
                          expirationMonth: expirationMonth,
                          expirationYear: expirationYear,
                        );

                        final token =
                            await PaymentService.instance.createCardToken(card);

                        if (token != '') {
                          print('TOKEN $token');

                          final user = _userCtrl.user.value;
                          if (user.conektaCustomerId == '' ||
                              user.conektaCustomerId == null) {
                            print('NO TIENE CONEKTAID');
                            final createCustomer = await PaymentService.instance
                                .createCustomer(token);

                            if (createCustomer) {
                              Get.back();
                              Dialogs.instance.showSnackBar(
                                DialogType.success,
                                'Se agregó el nuevo método de pago',
                                false,
                              );
                            }
                          } else {
                            print('SIII TIENE CONEKTAID');
                            final create = await PaymentService.instance
                                .createPaymentSource(token);

                            if (create) {
                              Get.back();
                              Dialogs.instance.showSnackBar(
                                DialogType.success,
                                'Se agregó el nuevo método de pago',
                                false,
                              );
                            }
                          }
                        } else {
                          print('NO HAY TOKENCARD');
                        }
                      } else {
                        print('invalid!');
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
