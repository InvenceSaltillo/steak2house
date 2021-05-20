import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../../../constants.dart';

class CardListBullets extends StatelessWidget {
  CardListBullets({
    Key? key,
  }) : super(key: key);

  final _paymentCtrl = Get.find<PaymentController>();
  final _utils = Utils.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: _utils.getHeightPercent(.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _paymentCtrl.cardsList.length + 1,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: index != _paymentCtrl.cardSelectedIdx.value
                    ? _utils.getWidthPercent(.02)
                    : _utils.getWidthPercent(.03),
                height: index != _paymentCtrl.cardSelectedIdx.value
                    ? _utils.getWidthPercent(.02)
                    : _utils.getWidthPercent(.03),
                decoration: BoxDecoration(
                  color: index == _paymentCtrl.cardSelectedIdx.value
                      ? kSecondaryColor
                      : kPrimaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
