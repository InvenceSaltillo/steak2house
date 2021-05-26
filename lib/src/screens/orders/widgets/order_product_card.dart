import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/models/user/detail_model.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../../../constants.dart';

class OrderProductCard extends StatelessWidget {
  OrderProductCard({
    Key? key,
    required this.orderItem,
    required this.delivery,
  }) : super(key: key);

  final Utils _utils = Utils.instance;
  final orderItem;
  final delivery;

  @override
  Widget build(BuildContext context) {
    final orderDetail = orderItem as Detail;
    return Card(
      margin: EdgeInsets.symmetric(vertical: _utils.getWidthPercent(.02)),
      elevation: 10,
      shadowColor: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        width: double.infinity,
        // height: _utils.getHeightPercent(.075),
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
                  orderDetail.picture!,
                  width: _utils.getHeightPercent(.095),
                  height: _utils.getHeightPercent(.095),
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, _) {
                    if (_ == null) return child;
                    return Center(
                      child: Lottie.asset(
                        'assets/animations/loading.json',
                        width: _utils.getWidthPercent(.15),
                        height: _utils.getWidthPercent(.095),
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/img/noImage.png',
                      width: _utils.getHeightPercent(.095),
                      height: _utils.getHeightPercent(.095),
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: _utils.getWidthPercent(.6),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${orderDetail.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: _utils.getWidthPercent(.6),
                          child: Text(
                            orderDetail.description!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${orderDetail.qty} x \$${orderDetail.price} = \$${int.parse(orderDetail.qty!) * int.parse(orderDetail.price!)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
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
