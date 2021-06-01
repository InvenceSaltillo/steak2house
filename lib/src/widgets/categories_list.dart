import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/controllers/categories_controller.dart';
import 'package:steak2house/src/services/products_service.dart';

import '../constants.dart';
import '../utils/utils.dart';

class CategoriesList extends StatelessWidget {
  CategoriesList({
    Key? key,
  }) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;
    final categoriesCtrl = Get.find<CategoriesController>();
    return Obx(
      () => SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: categoriesCtrl.categories.length == 0
            ? NeverScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categoriesCtrl.categories.length == 0
              ? List.generate(
                  4,
                  (index) => CategoryCard(
                    utils: _utils,
                    index: index,
                    scrollController: _scrollController,
                  ),
                )
              : List.generate(
                  categoriesCtrl.categories.length,
                  (index) => CategoryCard(
                    utils: _utils,
                    index: index,
                    scrollController: _scrollController,
                  ),
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
    required this.scrollController,
  })   : _utils = utils,
        super(key: key);

  final Utils _utils;
  final int index;
  final ScrollController scrollController;

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

                  if (categoriesCtrl.currentIndex.value >
                      (categoriesCtrl.categories.length / 3)) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  } else {
                    scrollController.animateTo(
                      scrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  }
                },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: categoriesCtrl.currentIndex.value == index
                ? _utils.getWidthPercent(.25)
                : _utils.getWidthPercent(.23),
            height: categoriesCtrl.currentIndex.value == index
                ? _utils.getHeightPercent(.17)
                : _utils.getHeightPercent(.15),
            decoration: BoxDecoration(
                color: categoriesCtrl.currentIndex.value == index
                    ? kPrimaryColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all()),
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
                      Image.asset(
                        'assets/img/${categoriesCtrl.categories[index].icon}.png',
                        width: _utils.getWidthPercent(.15),
                      ),
                      SizedBox(height: _utils.getWidthPercent(.03)),
                      Text(
                        '${categoriesCtrl.categories[index].name!.capitalize}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: categoriesCtrl.currentIndex.value == index
                              ? Colors.white
                              : kPrimaryColor,
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
