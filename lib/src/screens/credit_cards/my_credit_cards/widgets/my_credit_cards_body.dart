import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/screens/credit_cards/credit_card/credit_card_screen.dart';
import 'package:steak2house/src/screens/credit_cards/my_credit_cards/widgets/my_credit_card_detail.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';
import 'package:steak2house/src/widgets/empty_results.dart';
import 'package:steak2house/src/widgets/rounded_button.dart';

class MyCreditCardsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;
    final _paymentCtrl = Get.find<PaymentController>();
    return Scaffold(
      body: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _utils.getWidthPercent(.05),
            vertical: _utils.getHeightPercent(.03),
          ),
          child: _paymentCtrl.cardsList.length == 0
              ? EmptyResults(
                  text: 'No tienes tarjetas guardadas',
                  svgSrc: 'assets/img/emptyCards.svg',
                )
              : ListView.separated(
                  separatorBuilder: (_, __) =>
                      SizedBox(height: _utils.getHeightPercent(.02)),
                  itemCount: _paymentCtrl.cardsList.length,
                  itemBuilder: (_, idx) {
                    final _card = _paymentCtrl.cardsList[idx];
                    return InkWell(
                      onTap: () {
                        print('ID ${_card.id}');
                        Get.to(() => MyCreditCardDetail(),
                            arguments: [_card, idx]);
                      },
                      child: Container(
                        width: _utils.getWidthPercent(.9),
                        height: _utils.getHeightPercent(.1),
                        padding: EdgeInsets.symmetric(
                          vertical: _utils.getWidthPercent(.02),
                          horizontal: _utils.getWidthPercent(.05),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              kPrimaryColor,
                              Colors.indigo,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/${_card.brand}Card.png',
                                  width: _utils.getWidthPercent(.1),
                                  errorBuilder: (_, __, ___) {
                                    // return  Text('😢');
                                    return FaIcon(FontAwesomeIcons.creditCard);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${_card.name}'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _utils.getWidthPercent(.04),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '**** ${_card.last4}'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _utils.getWidthPercent(.04),
                                    letterSpacing: 3,
                                  ),
                                ),
                                SizedBox(width: _utils.getWidthPercent(.02)),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.white,
                                  size: _utils.getHeightPercent(.015),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      bottomNavigationBar: RoundedButton(
        text: 'Agregar nueva tarjeta',
        fontSize: .02,
        onTap: () {
          if (_paymentCtrl.cardsList.length >= 5) {
            return Dialogs.instance.showSnackBar(
              DialogType.error,
              '¡Solo puedes agregar 5 tarjetas, por favor elimina una!',
              false,
            );
          }
          Get.to(() => CreditCardScreen());
        },
      ),
    );
  }
}
