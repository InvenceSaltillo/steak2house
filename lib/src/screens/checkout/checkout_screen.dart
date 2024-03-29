import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/screens/checkout/widgets/body_checkout.dart';
import 'package:steak2house/src/services/payment_service.dart';
import 'package:steak2house/src/services/traffic_service.dart';
import 'package:steak2house/src/services/user_service.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';
import 'package:steak2house/src/widgets/payment_success.dart';
import 'package:steak2house/src/widgets/rounded_button.dart';

import '../../constants.dart';

class CheckOutScreen extends StatelessWidget {
  static String routeName = "/chekOut";
  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;
    final _miscCtrl = Get.find<MiscController>();
    final _cartCtrl = Get.find<CartController>();
    final _paymentCtrl = Get.find<PaymentController>();

    final _bottomNavCtrl = Get.find<BottomNavigationBarController>();

    if (_miscCtrl.isOpenFlag.value) {
      // _miscCtrl.timeIsOut();
      _miscCtrl.isOpenFlag.value = false;
    }
    // finalTrafficService.instance.getDeliveryDistance2Range(_locationCtrl.currentPosition.value.latitude, _locationCtrl.currentPosition.value.longitude;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            _miscCtrl.showAppBar.value = true;
            _bottomNavCtrl.currentPage.value = 3;
            _bottomNavCtrl.pageCtrl.value.jumpToPage(3);
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Tu pedido',
          style: TextStyle(
            fontSize: _utils.getHeightPercent(.05),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: BodyCheckOut(),
      bottomNavigationBar: Obx(
        () => (!_miscCtrl.isOpen.value)
            ? Container(height: 50)
            : RoundedButton(
                text:
                    'Terminar Pedido \$${_miscCtrl.totalPriceDelivery.ceil()}',
                fontSize: .02,
                height: .05,
                width: .5,
                onTap: () async {
                  if (_paymentCtrl.cardsList.length == 0) {
                    return Dialogs.instance.showSnackBar(
                      DialogType.info,
                      '¡Primero debes agregar una tarjeta!',
                      false,
                    );
                  }

                  bool hasAlcohol = false;

                  _cartCtrl.cartList.forEach((element) {
                    if (element.product!.categoryId == '2') {
                      hasAlcohol = true;
                    }
                  });

                  final createCharge =
                      await PaymentService.instance.createCharge();

                  if (createCharge) {
                    Get.to(
                      () => PaymentSuccess(),
                      fullscreenDialog: true,
                      arguments: {'hasAlcohol': hasAlcohol},
                    );

                    await UserService.instance.sendTelegramMessage();
                    await SharedPrefs.instance.deleteKey('cartList');
                    _cartCtrl.cartList.value = [];
                  }
                },
              ),
      ),
    );
  }
}
