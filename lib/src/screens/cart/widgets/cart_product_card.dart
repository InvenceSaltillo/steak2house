import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/models/cart_model.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

import '../../../constants.dart';

class CartProductCard extends StatelessWidget {
  CartProductCard({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final Utils _utils = Utils.instance;
  final Cart cartItem;
  final _cartCtrl = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: _utils.getWidthPercent(.02)),
      elevation: 10,
      shadowColor: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        width: double.infinity,
        height: _utils.getHeightPercent(.13),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  cartItem.product!.picture!,
                  width: _utils.getHeightPercent(.14),
                  height: _utils.getHeightPercent(.15),
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, _) {
                    if (_ == null) return child;
                    return Center(
                      child: Lottie.asset(
                        'assets/animations/loading.json',
                        width: _utils.getWidthPercent(.3),
                        height: _utils.getWidthPercent(.25),
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/img/noImage.png',
                      width: _utils.getHeightPercent(.14),
                      height: _utils.getHeightPercent(.15),
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: _utils.getWidthPercent(.55),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${cartItem.product!.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final result =
                                await Dialogs.instance.showLottieDialog(
                              title:
                                  '¿Estas seguro de eliminar este producto del carrito?',
                              lottieSrc: 'assets/animations/delete.json',
                              firstButtonText: 'Eliminar',
                              secondButtonText: 'Cancelar',
                              firstButtonBgColor: Colors.red,
                              secondButtonBgColor: Colors.transparent,
                              firstButtonTextColor: Colors.white,
                              secondButtonTextColor: Colors.black54,
                            );

                            if (result) {
                              final productIdx = _cartCtrl.cartList.indexWhere(
                                (item) =>
                                    item.product!.id == cartItem.product!.id,
                              );

                              _cartCtrl.cartList
                                  .remove(_cartCtrl.cartList[productIdx]);
                              // _cartCtrl.cartList.value = [];

                              SharedPrefs.instance.setKey(
                                'cartList',
                                json.encode(_cartCtrl.cartList),
                              );

                              _cartCtrl.totalCart.value = 0;
                              _cartCtrl.updateTotal();
                            }
                          },
                          child: Icon(
                            Icons.clear,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: _utils.getWidthPercent(.45),
                          child: Text(
                            cartItem.product!.description!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment:
                      //     MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // '\$${cartItem.product!.price}',
                          '${cartItem.qty} x \$${cartItem.product!.price} = \$${cartItem.qty! * int.parse(cartItem.product!.price!)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
