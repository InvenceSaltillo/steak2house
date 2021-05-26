import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/models/user/my_orders_model.dart';
import 'package:steak2house/src/utils/utils.dart';

import 'order_product_card.dart';

class OrderDetail extends StatelessWidget {
  var delivery = 0.0;
  var total = 0.0;

  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;

    final MyOrders _order = Get.arguments[0];

    delivery = double.parse(
        _order.delivery!.substring(0, _order.delivery!.length - 2));
    total = double.parse(_order.total!.substring(0, _order.total!.length - 2)) -
        delivery;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            // _miscCtrl.showAppBar.value = true;
            // _bottomNavCtrl.pageCtrl.value.jumpToPage(3);
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Detalle del pedido',
          style: TextStyle(
            fontSize: _utils.getHeightPercent(.03),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            // height: _utils.getHeightPercent(.9),
            child: ListView.builder(
              itemCount: _order.detail!.length,
              itemBuilder: (_, idx) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: _utils.getWidthPercent(.05),
                    right: _utils.getWidthPercent(.05),
                  ),
                  child: OrderProductCard(
                    orderItem: _order.detail![idx],
                    delivery: _order.delivery,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: _utils.getHeightPercent(.25),
        padding: EdgeInsets.all(_utils.getWidthPercent(.05)),
        decoration: BoxDecoration(
          color: kPrimaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Resúmen del pedido',
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: _utils.getHeightPercent(.03),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal productos',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: _utils.getHeightPercent(.02),
                  ),
                ),
                Text(
                  '\$${Utils.instance.quitZeros(_order.subtotal!)}',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: _utils.getHeightPercent(.02),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Envío',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: _utils.getHeightPercent(.02),
                  ),
                ),
                Text(
                  '\$${Utils.instance.quitZeros(_order.delivery!)}',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: _utils.getHeightPercent(.02),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: _utils.getHeightPercent(.035),
                  ),
                ),
                Text(
                  '\$${(double.parse(Utils.instance.quitZeros(_order.delivery!)) + double.parse(Utils.instance.quitZeros(_order.subtotal!))).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: _utils.getHeightPercent(.025),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // Center(
      //   child: Material(
      //     child: InkWell(
      //       onTap: () async {
      //         print(_order.detail!.length);

      //         _cartCtrl.cartList.value = [];

      //         for (var item in _order.detail!) {
      //           _cartCtrl.cartList.add(
      //             new Cart(
      //               product: Product(
      //                 id: item.id,
      //                 name: item.name,
      //                 description: item.description,
      //                 price: item.price,
      //                 existence: item.existence,
      //                 includes: item.includes,
      //                 status: item.status,
      //                 picture: item.picture,
      //               ),
      //               qty: int.parse(item.qty!),
      //             ),
      //           );
      //         }

      //         await Future.delayed(Duration(milliseconds: 500));

      //         // final distance =
      //         //     await TrafficService.instance.getDeliveryDistance();
      //         // _miscCtrl.deliveryDistance.value = distance;
      //         _cartCtrl.totalCart.value = 0;
      //         _cartCtrl.updateTotal();
      //         _miscCtrl.showAppBar.value = false;
      //         _bottomNavCtrl.pageCtrl.value.jumpToPage(5);
      //         Get.back();
      //       },
      //       child: Container(
      //         width: _utils.getHeightPercent(.35),
      //         height: _utils.getHeightPercent(.05),
      //         decoration: BoxDecoration(
      //           color: kPrimaryColor,
      //           borderRadius: BorderRadius.circular(50),
      //         ),
      //         child: Center(
      //           child: Text(
      //             'Pedir de nuevo \$${Utils.instance.quitZeros(_order.subtotal!)}',
      //             style: TextStyle(
      //               color: kSecondaryColor,
      //               fontWeight: FontWeight.bold,
      //               fontSize: _utils.getHeightPercent(.02),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // ),
    );
  }
}
