import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../../../constants.dart';

class CheckOutProductsCard extends StatelessWidget {
  CheckOutProductsCard({
    Key? key,
  }) : super(key: key);

  final _cartCtrl = Get.find<CartController>();

  final _utils = Utils.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: _cartCtrl.cartList.length == 1
              ? _utils.getHeightPercent(.10)
              : _cartCtrl.cartList.length == 2
                  ? _utils.getHeightPercent(.18)
                  : _cartCtrl.cartList.length == 3
                      ? _utils.getHeightPercent(.28)
                      : _utils.getHeightPercent(.36),
          child: Card(
            elevation: 5,
            child: ListView.separated(
              physics: _cartCtrl.cartList.length < 5
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              itemCount: _cartCtrl.cartList.length,
              separatorBuilder: (_, __) => Divider(
                height: .05,
                thickness: 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                final cartItem = _cartCtrl.cartList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: kPrimaryColor,
                    child: Container(
                      // padding: EdgeInsets.all(8),
                      child: ClipOval(
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
                      )
                          // FadeInImage.assetNetwork(
                          //   placeholder: 'assets/animations/loading.gif',
                          //   fit: BoxFit.cover,
                          //   image: cartItem.product!.picture!,
                          // ),
                          ),
                    ),
                  ),
                  title: Text('${cartItem.product!.name}'),
                  subtitle: Text(
                    '${cartItem.qty} x \$${cartItem.product!.price}',
                  ),
                );
              },
            ),
          ),
        ),
        if (_cartCtrl.cartList.length > 4)
          Positioned(
            right: 10,
            bottom: 10,
            child: FadeInDown(
              from: 150,
              child: Icon(Icons.arrow_downward_rounded),
            ),
          ),
      ],
    );
  }
}
