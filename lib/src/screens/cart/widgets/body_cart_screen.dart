import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';

import 'package:steak2house/src/screens/cart/widgets/cart_product_card.dart';

import 'package:steak2house/src/utils/utils.dart';

class BodyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _cartCtrl = Get.find<CartController>();
    final _bottomNavCtrl = Get.find<BottomNavigationBarController>();
    final _utils = Utils.instance;
    _cartCtrl.totalCart.value = 0;
    _cartCtrl.updateTotal();

    return Obx(
      () => _cartCtrl.cartList.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/img/emptyCart.svg',
                    width: _utils.getWidthPercent(.7),
                  ),
                  Text(
                    'Tu carrito esta vacío',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.025),
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  Container(
                    width: _utils.getWidthPercent(.5),
                    child: Text(
                      'Parece que no haz agregado ningun producto aún',
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                  SizedBox(height: _utils.getHeightPercent(.02)),
                  TextButton(
                    onPressed: () async {
                      _bottomNavCtrl.pageCtrl.value.animateToPage(
                        0,
                        duration: Duration(milliseconds: 700),
                        curve: Curves.decelerate,
                      );
                      _bottomNavCtrl.currentPage.value = 0;
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(_utils.getWidthPercent(.4), 20),
                      backgroundColor: kPrimaryColor,
                      padding: EdgeInsets.all(_utils.getHeightPercent(.01)),
                    ),
                    child: Text(
                      'Empieza a comprar',
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: _utils.getHeightPercent(.02),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: _utils.getHeightPercent(.05)),
                Padding(
                  padding: EdgeInsets.only(
                    left: _utils.getWidthPercent(.05),
                    right: _utils.getWidthPercent(.05),
                  ),
                  child: Text(
                    '${_cartCtrl.cartList.length} producto(s) agregado(s)',
                    style: TextStyle(fontSize: _utils.getWidthPercent(.05)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartCtrl.cartList.length,
                    itemBuilder: (_, idx) {
                      final cartItem = _cartCtrl.cartList[idx];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: _utils.getWidthPercent(.05),
                          right: _utils.getWidthPercent(.05),
                        ),
                        child: CartProductCard(cartItem: cartItem),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () async {},
                    style: TextButton.styleFrom(
                      minimumSize: Size(_utils.getWidthPercent(.6), 20),
                      backgroundColor: kPrimaryColor,
                      padding: EdgeInsets.all(_utils.getHeightPercent(.01)),
                    ),
                    child: Text(
                      'Pagar \$${_cartCtrl.totalCart.value}',
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: _utils.getHeightPercent(.02),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
