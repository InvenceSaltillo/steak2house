import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/utils/utils.dart';

class CheckOutSummaryCard extends StatelessWidget {
  CheckOutSummaryCard({
    Key? key,
  }) : super(key: key);

  final _cartCtrl = Get.find<CartController>();
  final _miscCtrl = Get.find<MiscController>();

  final _utils = Utils.instance;

  @override
  Widget build(BuildContext context) {
    _miscCtrl.updateDeliveryPrice();
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen',
              style: TextStyle(
                fontSize: _utils.getHeightPercent(.02),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _utils.getHeightPercent(.01)),
            Divider(height: .05, thickness: 1),
            SizedBox(height: _utils.getHeightPercent(.01)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Productos',
                  style: TextStyle(
                    fontSize: _utils.getHeightPercent(.018),
                  ),
                ),
                Text(
                  '\$${_cartCtrl.totalCart}',
                  style: TextStyle(
                    fontSize: _utils.getHeightPercent(.018),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: _utils.getHeightPercent(.01)),
            Divider(height: .05, thickness: 1),
            SizedBox(height: _utils.getHeightPercent(.01)),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Envío ',
                    // 'Envío -${_miscCtrl.deliveryDistance.value}',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.018),
                    ),
                  ),
                  Text(
                    _miscCtrl.deliveryDistance < 5
                        ? '\$50'
                        : '${_miscCtrl.calculateDistance.value ? 'Calculando...' : '\$${(_miscCtrl.deliveryDistance.value * _miscCtrl.priceKM.value).ceil()}'} ',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.018),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
