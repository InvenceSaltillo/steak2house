import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/product_controller.dart';

import '../../../constants.dart';
import '../../../utils/utils.dart';

class ProductDetailBottomNav extends StatelessWidget {
  const ProductDetailBottomNav({
    Key? key,
    required Utils utils,
  })   : _utils = utils,
        super(key: key);

  final Utils _utils;
  // final ProductController productCtrl;

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
                onPressed: () {},
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
