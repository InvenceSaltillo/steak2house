import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/controllers/categories_controller.dart';
import 'package:steak2house/src/services/products_service.dart';

import '../constants.dart';
import '../utils/utils.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;
    final categoriesCtrl = Get.find<CategoriesController>();
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: categoriesCtrl.categories.length == 0
            ? NeverScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categoriesCtrl.categories.length == 0
              ? List.generate(
                  4,
                  (index) => CategoryCard(utils: _utils, index: index),
                )
              : List.generate(
                  categoriesCtrl.categories.length,
                  (index) => CategoryCard(utils: _utils, index: index),
                ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required Utils utils,
    required this.index,
  })   : _utils = utils,
        super(key: key);

  final Utils _utils;
  final int index;

  @override
  Widget build(BuildContext context) {
    final categoriesCtrl = Get.find<CategoriesController>();
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(
          right: _utils.getWidthPercent(.02),
          top: _utils.getHeightPercent(.01),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: categoriesCtrl.categories.length == 0
              ? null
              : () async {
                  categoriesCtrl.currentIndex.value = index;
                  final String categoryId =
                      categoriesCtrl.categories[index].id.toString();
                  ProductService.instance.getByCategory(categoryId);
                },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: categoriesCtrl.currentIndex.value == index
                ? _utils.getWidthPercent(.25)
                : _utils.getWidthPercent(.23),
            height: categoriesCtrl.currentIndex.value == index
                ? _utils.getHeightPercent(.15)
                : _utils.getHeightPercent(.13),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: categoriesCtrl.categories.length == 0
                ? Center(
                    child: Lottie.asset(
                      'assets/animations/loading.json',
                      width: _utils.getWidthPercent(.3),
                      height: _utils.getWidthPercent(.3),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/img/${categoriesCtrl.categories[index].icon}.svg',
                        width: _utils.getWidthPercent(.15),
                      ),
                      SizedBox(height: _utils.getWidthPercent(.03)),
                      Text(
                        '${categoriesCtrl.categories[index].name!.capitalize}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
