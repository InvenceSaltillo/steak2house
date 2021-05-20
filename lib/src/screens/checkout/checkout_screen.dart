import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/screens/checkout/widgets/body_checkout.dart';
import 'package:steak2house/src/screens/credit_card/credit_card_screen.dart';
import 'package:steak2house/src/services/payment_service.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/payment_success.dart';

class CheckOutScreen extends StatelessWidget {
  static String routeName = "/chekOut";
  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;
    final _miscCtrl = Get.find<MiscController>();
    final _cartCtrl = Get.find<CartController>();

    final _bottomNavCtrl = Get.find<BottomNavigationBarController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _miscCtrl.showAppBar.value = true;
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
      bottomNavigationBar: Container(
        height: _utils.getHeightPercent(.07),
        decoration: BoxDecoration(
            // color: Colors.black.withOpacity(.06),
            ),
        child: Obx(
          () => Center(
            child: Material(
              child: InkWell(
                onTap: () async {
                  final createCharge =
                      await PaymentService.instance.createCharge();

                  if (createCharge) {
                    await SharedPrefs.instance.deleteKey('cartList');
                    _cartCtrl.cartList.value = [];
                    Get.to(
                      () => PaymentSuccess(),
                      fullscreenDialog: true,
                    );
                  }
                },
                child: Container(
                  width: _utils.getHeightPercent(.35),
                  height: _utils.getHeightPercent(.05),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Terminar Pedido \$${_miscCtrl.totalPriceDelivery.toStringAsFixed(2)}',
                      // 'Terminar Pedido \$${(_cartCtrl.totalCart.value + (_miscCtrl.deliveryDistance.value * _miscCtrl.priceKM.value)).toStringAsFixed(2)}',
                      // 'Ir a Pagar \$${_cartCtrl.totalCart.value}',
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
          ),
        ),
      ),
    );
  }
}
