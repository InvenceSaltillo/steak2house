import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/empty_results.dart';

import 'orders_list_card.dart';

class BodyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userCtrl = Get.find<UserController>();
    final _utils = Utils.instance;
    return Obx(
      () => _userCtrl.ordersList.length == 0
          ? EmptyResults(
              text: 'Aún no tienes pedidos realizados',
              svgSrc: 'assets/img/emptyOrders.svg')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: _utils.getWidthPercent(.05),
                    right: _utils.getWidthPercent(.05),
                  ),
                  child: Text(
                    _userCtrl.ordersList.length == 1
                        ? '${_userCtrl.ordersList.length} pedido completado'
                        : '${_userCtrl.ordersList.length} pedidos completados',
                    style: TextStyle(fontSize: _utils.getWidthPercent(.05)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _userCtrl.ordersList.length,
                    itemBuilder: (_, idx) {
                      final order = _userCtrl.ordersList[idx];

                      return Padding(
                        padding: EdgeInsets.only(
                          left: _utils.getWidthPercent(.02),
                          right: _utils.getWidthPercent(.02),
                        ),
                        child: OrdersListCard(order: order),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
