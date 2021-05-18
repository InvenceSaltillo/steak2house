import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/screens/main/main_screen.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/rounded_small_button.dart';
import 'package:steak2house/src/widgets/search_products.dart';

class ProductDetailImage extends StatelessWidget {
  const ProductDetailImage({
    Key? key,
  }) : super(key: key);

  // final Product product;
  @override
  Widget build(BuildContext context) {
    late AnimationController _animationController;
    final _utils = Utils.instance;

    final _producCtrl = Get.find<ProductController>();

    // _producCtrl.isLiked.value = _producCtrl.currentProduct.value.isLiked;

    return Container(
      width: _utils.getWidthPercent(1),
      padding: EdgeInsets.only(
        top: _utils.getHeightPercent(.05),
        bottom: _utils.getHeightPercent(.03),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: kPrimaryColor,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Center(
              // heightFactor: .77,
              child: Hero(
                tag: '${_producCtrl.currentProduct.value.id}',
                child: Image.network(
                  _producCtrl.currentProduct.value.picture!,
                  fit: BoxFit.fitWidth,
                  loadingBuilder: (ctx, child, _) {
                    if (_ == null) return child;
                    return Center(
                      child: Lottie.asset(
                        'assets/animations/loading.json',
                        width: _utils.getWidthPercent(.3),
                        height: _utils.getWidthPercent(.3),
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/img/noImage.png',
                      height: _utils.getHeightPercent(.25),
                      width: _utils.getHeightPercent(.25),
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: RoundedSmallButton(
              onTap: () {
                if (_producCtrl.fromSearch.value) {
                  Get.off(() => MainScreen());
                  showSearch(context: context, delegate: SearchProducts());
                  _producCtrl.fromSearch.value = false;
                  _producCtrl.querySearch.value = '';
                } else {
                  _producCtrl.querySearch.value = '';
                  Get.off(() => MainScreen());
                }
              },
              utils: _utils,
              width: .08,
              height: .08,
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                size: _utils.getWidthPercent(.055),
              ),
            ),
          ),
          Obx(
            () {
              final exist = _producCtrl.favoriteList.where(
                (favorite) =>
                    favorite.id == _producCtrl.currentProduct.value.id,
              );

              _producCtrl.isLiked.value = !exist.isBlank!;
              return Positioned(
                bottom: 20,
                right: 20,
                child: RoundedSmallButton(
                  onTap: () {
                    if (!_producCtrl.isLiked.value) {
                      _animationController.forward(from: 0);
                    }

                    final exist = _producCtrl.favoriteList.where(
                      (favorite) =>
                          favorite.id == _producCtrl.currentProduct.value.id,
                    );

                    _producCtrl.isLiked.value = exist.isBlank!;

                    if (exist.isBlank == true) {
                      _producCtrl.currentProduct.value.isLiked =
                          !_producCtrl.currentProduct.value.isLiked;

                      _producCtrl.favoriteList
                          .add(_producCtrl.currentProduct.value);
                    } else {
                      final itemIdx = _producCtrl.favoriteList.indexWhere(
                          (item) =>
                              item.id == _producCtrl.currentProduct.value.id);
                      _producCtrl.favoriteList.removeAt(itemIdx);
                    }
                    SharedPrefs.instance.setKey(
                      'favoriteList',
                      json.encode(_producCtrl.favoriteList),
                    );
                  },
                  utils: _utils,
                  width: .08,
                  height: .08,
                  icon: Pulse(
                    duration: Duration(milliseconds: 300),
                    animate: false,
                    controller: (controller) =>
                        _animationController = controller,
                    child: Icon(
                      _producCtrl.isLiked.value
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      size: _utils.getWidthPercent(.055),
                      color: _producCtrl.isLiked.value
                          ? Colors.red
                          : kPrimaryColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
