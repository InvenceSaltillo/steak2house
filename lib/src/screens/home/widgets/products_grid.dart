import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/product_card.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;
    final productCtrl = Get.find<ProductController>();

    return Obx(
      () => productCtrl.loading.value
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/loading.json',
                    width: _utils.getWidthPercent(.3),
                    height: _utils.getWidthPercent(.3),
                  ),
                  Text(
                    'Cargando...',
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            )
          : productCtrl.products.length == 0
              ? Center(
                  child: Text(
                    'No hay productos en esta categoría😪',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.027),
                    ),
                  ),
                )
              : SizedBox(
                  height: Get.size.height > 800
                      ? _utils.getHeightPercent(.43)
                      : _utils.getHeightPercent(.4),
                  // height: 260,
                  child: GridView.count(
                    physics: BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    children: [
                      ...List.generate(
                        productCtrl.products.length,
                        (index) {
                          return ProductCard(
                            product: productCtrl.products[index],
                          );
                        },
                      ),
                      // SizedBox(height: 5),
                    ],
                  ),
                ),
    );
  }
}
