import 'package:flutter/material.dart';
import 'package:steak2house/src/screens/home/widgets/products_grid.dart';
import 'package:steak2house/src/widgets/categories_list.dart';
import 'package:steak2house/src/widgets/search_text_field.dart';

import '../../../constants.dart';
import '../../../utils/utils.dart';

class BodyHomeScreen extends StatelessWidget {
  final _utils = Utils.instance;

  final TextEditingController _controller = TextEditingController();

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
            SearchTextField(
              onChanged: (value) {},
              onSubmitted: (value) {},
              controller: _controller,
              icon: Icons.search,
              hintText: 'Buscar...',
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
              height: _utils.getHeightPercent(.16),
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
            // Container(
            //   width: 100,
            //   height: 100,
            //   child: TextButton(
            //     onPressed: () {},
            //     style: TextButton.styleFrom(
            //         backgroundColor: kPrimaryColor,
            //         primary: Colors.white,
            //         shape: CircleBorder()),
            //     child: Text('OK'),
            //   ),
            // ),
            // SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
