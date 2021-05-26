import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:steak2house/src/models/user/my_orders_model.dart';
import 'package:steak2house/src/screens/orders/widgets/order_detail.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../../../constants.dart';

class OrdersListCard extends StatelessWidget {
  OrdersListCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  final _utils = Utils.instance;
  final MyOrders order;

  @override
  Widget build(BuildContext context) {
    final dateStr = order.createdAt!;
    final date = DateFormat('d MMMM, yyyy', 'es_MX').format(dateStr);

    final time = DateFormat('h:mm a', 'es_MX').format(dateStr);

    final dateTime = '$date $time';
    return Card(
      elevation: 10,
      child: InkWell(
        onTap: () {
          Get.to(() => OrderDetail(), arguments: [order]);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: kPrimaryColor,
                child: ClipOval(
                  child: Image.asset(
                    'assets/img/steak.png',
                    width: _utils.getWidthPercent(.07),
                  ),
                ),
              ),
              SizedBox(width: _utils.getWidthPercent(.05)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total: \$${Utils.instance.quitZeros(order.subtotal!)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('$dateTime'),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Get.to(() => OrderDetail(), arguments: [order]);
                },
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
