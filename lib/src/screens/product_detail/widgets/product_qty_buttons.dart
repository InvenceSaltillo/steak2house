import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/widgets/rounded_small_button.dart';

import '../../../constants.dart';
import '../../../utils/utils.dart';

class ProductQtyButtons extends StatelessWidget {
  const ProductQtyButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Utils _utils = Utils.instance;
    final productCtrl = Get.find<ProductController>();
    return Obx(
      () => Row(
        children: [
          SizedBox(width: _utils.getWidthPercent(.008)),
          Container(
            width: _utils.getWidthPercent(.7),
            child: Text(
              productCtrl.currentProduct.value.description!,
              overflow: TextOverflow.fade,
              // softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          RoundedSmallButton(
            onTap: () {
              if (productCtrl.productQty.value == 1) return;
              productCtrl.decrement();
            },
            utils: _utils,
            width: .065,
            height: .065,
            color: kPrimaryColor,
            icon: Icon(
              Icons.remove,
              color: kSecondaryColor,
              size: _utils.getWidthPercent(.04),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _utils.getWidthPercent(.01)),
            child: Text(
              '${productCtrl.productQty < 10 ? '0' : ''}${productCtrl.productQty}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _utils.getHeightPercent(.025),
              ),
            ),
          ),
          RoundedSmallButton(
            onTap: () {
              productCtrl.increment();
            },
            utils: _utils,
            width: .065,
            height: .065,
            color: kPrimaryColor,
            icon: Icon(
              Icons.add,
              color: kSecondaryColor,
              size: _utils.getWidthPercent(.04),
            ),
          ),
        ],
      ),
    );
  }
}
