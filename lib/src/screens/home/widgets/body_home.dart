import 'package:flutter/material.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/screens/home/widgets/products_grid.dart';
import 'package:steak2house/src/widgets/categories_list.dart';
import 'package:steak2house/src/widgets/search_products.dart';

import '../../../utils/utils.dart';

class BodyHomeScreen extends StatelessWidget {
  final _utils = Utils.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _utils.getWidthPercent(.02)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Qué te gustaría pedir?',
              style: TextStyle(
                fontSize: _utils.getWidthPercent(.08),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _utils.getWidthPercent(.03)),
            GestureDetector(
              onTap: () async {
                showSearch(context: context, delegate: SearchProducts());
              },
              child: Container(
                width: double.infinity,
                height: _utils.getHeightPercent(.05),
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(width: _utils.getWidthPercent(.01)),
                    Icon(Icons.search),
                    SizedBox(width: _utils.getWidthPercent(.01)),
                    Text(
                      'Buscar...',
                      style: TextStyle(
                        fontSize: _utils.getWidthPercent(.05),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: _utils.getWidthPercent(.03)),
            Container(
              child: Text(
                'Categorías',
                style: TextStyle(
                  fontSize: _utils.getWidthPercent(.05),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: _utils.getHeightPercent(.19),
              child: CategoriesList(),
            ),
            SizedBox(height: _utils.getWidthPercent(.02)),
            Container(
              child: Text(
                'Popular',
                style: TextStyle(
                  fontSize: _utils.getWidthPercent(.05),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: _utils.getWidthPercent(.01)),
            ProductsGrid(),
          ],
        ),
      ),
    );
  }
}
