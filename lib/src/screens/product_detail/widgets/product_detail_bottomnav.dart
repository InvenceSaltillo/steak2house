import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/models/cart_model.dart';
import 'package:steak2house/src/screens/main/main_screen.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

import '../../../constants.dart';
import '../../../utils/utils.dart';

class ProductDetailBottomNav extends StatelessWidget {
  ProductDetailBottomNav({
    Key? key,
  }) : super(key: key);

  final Utils _utils = Utils.instance;
  final _cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final productCtrl = Get.find<ProductController>();
    productCtrl.productTotal.value =
        double.parse(productCtrl.currentProduct.value.price!);
    return Obx(
      () => Container(
        width: double.infinity,
        height: _utils.getHeightPercent(.1),
        decoration: BoxDecoration(
          color: kPrimaryColor,
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: _utils.getWidthPercent(.05)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Total ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _utils.getHeightPercent(.035),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${productCtrl.productTotal.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _utils.getHeightPercent(.035),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () async {
                  final newCartItem = new Cart(
                    product: productCtrl.currentProduct.value,
                    qty: productCtrl.productQty.value,
                  );

                  final exist = _cartController.cartList.where((cartItem) =>
                      cartItem.product!.id == newCartItem.product!.id);

                  if (exist.isBlank == true) {
                    _cartController.cartList.add(newCartItem);
                  } else {
                    final itemIdx = _cartController.cartList.indexWhere(
                        (item) => item.product!.id == newCartItem.product!.id);
                    _cartController.cartList[itemIdx].qty =
                        _cartController.cartList[itemIdx].qty! +
                            productCtrl.productQty.value;
                  }

                  final result = await Dialogs.instance.showLottieDialog(
                    title:
                        '!Se agregó ${productCtrl.currentProduct.value.name} al carrito¡',
                    lottieSrc: 'assets/animations/addCart.json',
                    firstButtonText: 'Ok',
                    secondButtonText: '',
                    firstButtonBgColor: kPrimaryColor,
                    firstButtonTextColor: kSecondaryColor,
                    secondButtonBgColor: kPrimaryColor,
                    secondButtonTextColor: kSecondaryColor,
                  );

                  if (result) {
                    SharedPrefs.instance.setKey(
                      'cartList',
                      json.encode(_cartController.cartList),
                    );
                    if (productCtrl.fromSearch.value) {
                      Get.off(() => MainScreen());
                      productCtrl.fromSearch.value = false;
                      productCtrl.querySearch.value = '';
                    } else {
                      productCtrl.querySearch.value = '';
                      Get.off(() => MainScreen());
                    }
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.all(_utils.getHeightPercent(.01))),
                child: Text(
                  'Agregar al carrito',
                  style: TextStyle(
                    color: Colors.white,
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
