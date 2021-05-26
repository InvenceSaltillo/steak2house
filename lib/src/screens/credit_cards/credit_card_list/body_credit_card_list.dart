import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/utils/utils.dart';

import 'widgets/card_list_bullets.dart';
import 'widgets/card_list_button.dart';

class BodyCreditCardList extends StatefulWidget {
  @override
  _BodyCreditCardListState createState() => _BodyCreditCardListState();
}

class _BodyCreditCardListState extends State<BodyCreditCardList> {
  final _paymentCtrl = Get.find<PaymentController>();
  final _utils = Utils.instance;

  final _pageController = PageController();

  void _listener() {
    _paymentCtrl.pageControllerPage.value = _pageController.page!;
  }

  @override
  void initState() {
    _paymentCtrl.cardSelectedIdx.value = 0;
    _pageController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: _utils.getWidthPercent(1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.clear, color: kPrimaryColor),
            ),
            Container(
              width: _utils.getWidthPercent(1),
              height: _utils.getWidthPercent(.6),
              child: PageView(
                onPageChanged: (index) =>
                    _paymentCtrl.cardSelectedIdx.value = index,
                children: [
                  ...List.generate(
                    _paymentCtrl.cardsList.length,
                    (idx) {
                      final _card = _paymentCtrl.cardsList[idx];
                      return ZoomIn(
                        duration: Duration(milliseconds: 600),
                        child: CreditCardWidget(
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
                      );
                    },
                  ),
                  ZoomIn(
                    duration: Duration(milliseconds: 600),
                    child: Container(
                      padding: EdgeInsets.all(_utils.getHeightPercent(.02)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.all(_utils.getWidthPercent(.03)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: kSecondaryColor),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.creditCard,
                                  color: kSecondaryColor,
                                ),
                              ),
                              SizedBox(height: _utils.getHeightPercent(.015)),
                              Text(
                                'Agregar nueva tarjeta',
                                style: TextStyle(color: kSecondaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CardListBullets(),
            SizedBox(height: _utils.getHeightPercent(.03)),
            CardListButton()
          ],
        ),
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
