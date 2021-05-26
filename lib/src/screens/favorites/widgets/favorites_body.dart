import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/screens/favorites/widgets/favorite_product_card.dart';
import 'package:steak2house/src/utils/utils.dart';

class FavoritesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _productCtrl = Get.find<ProductController>();
    final _utils = Utils.instance;
    return Obx(
      () => _productCtrl.favoriteList.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/img/emptyFavorites.svg',
                    width: _utils.getWidthPercent(.7),
                  ),
                  Text(
                    '¡Vaya! Aún no tienes ningun favorito',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.025),
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _productCtrl.favoriteList.length,
              itemBuilder: (_, idx) {
                final favorite = _productCtrl.favoriteList[idx];
                return Padding(
                  padding: EdgeInsets.only(
                    left: _utils.getWidthPercent(.05),
                    right: _utils.getWidthPercent(.05),
                  ),
                  child: FavoriteProductCard(favorite: favorite),
                );
              },
            ),
    );
  }
}
