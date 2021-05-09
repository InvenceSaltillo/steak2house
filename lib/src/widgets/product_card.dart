import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/models/product_model.dart';
import 'package:steak2house/src/screens/product_detail/product_detail_screen.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../constants.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final productCtrl = Get.find<ProductController>();
    final Utils _utils = Utils.instance;
    return GestureDetector(
      onTap: () {
        productCtrl.currentProduct.value = product;
        productCtrl.productQty.value = 1;
        Get.offNamedUntil(ProductDetailScreen.routeName, (_) => false);
      },
      child: Container(
        margin: EdgeInsets.all(_utils.getWidthPercent(.01)),
        width: double.infinity,
        // height: 200,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Hero(
                tag: '${product.id}',
                child: Image.network(
                  product.picture!,
                  height: _utils.getHeightPercent(.125),
                  width: 200,
                  fit: BoxFit.fitWidth,
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
                      height: _utils.getHeightPercent(.125),
                      width: _utils.getHeightPercent(.125),
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _utils.getWidthPercent(.02),
                vertical: _utils.getWidthPercent(.02),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // 'Rib-Eye Premium Alv',
                    product.name!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text(
                  //   '800g',
                  //   style: TextStyle(
                  //     color: Colors.white38,
                  //     fontWeight: FontWeight.w100,
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _utils.getWidthPercent(.02),
                vertical: _utils.getWidthPercent(.02),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _utils.getWidthPercent(.31),
                    child: Text(
                      '${product.description}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white38,
                          fontSize: _utils.getWidthPercent(.03)
                          // fontWeight: FontWeight.w100,
                          ),
                    ),
                  ),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      color: kSecondaryColor,
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
