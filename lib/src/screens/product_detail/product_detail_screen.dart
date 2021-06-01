import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/screens/main/main_screen.dart';

import 'widgets/product_detail_bottomnav.dart';
import 'widgets/product_list_info.dart';
import 'package:steak2house/src/utils/utils.dart';

import 'widgets/product_detail_image.dart';
import 'widgets/product_qty_buttons.dart';

class ProductDetailScreen extends StatelessWidget {
  static final routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;

    final productCtrl = Get.find<ProductController>();
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // Get.off(() => MainScreen());

          print('ORDERSPOP');
          Get.back();
          return false;
        },
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: _utils.getWidthPercent(.03)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductDetailImage(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productCtrl.currentProduct.value.name!,
                    style: TextStyle(
                      fontSize: _utils.getWidthPercent(.055),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text(
                  //   '500g',
                  //   style: TextStyle(
                  //     fontSize: _utils.getWidthPercent(.05),
                  //     color: kSecondaryColor,
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: _utils.getHeightPercent(.005)),
              // PorductReviewsPercent(utils: _utils),
              SizedBox(height: _utils.getHeightPercent(.02)),
              ProductQtyButtons(),
              Divider(
                height: _utils.getHeightPercent(.03),
                color: kPrimaryColor,
              ),
              // SizedBox(height: _utils.getHeightPercent(.005)),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  'Información',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                height: _utils.getHeightPercent(.03),
                color: kPrimaryColor,
              ),
              ProductListInfo(
                includes: productCtrl.currentProduct.value.includes,
              ),

              SizedBox(height: _utils.getHeightPercent(.005)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProductDetailBottomNav(),
    );
  }
}
