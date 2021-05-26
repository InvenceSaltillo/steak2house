import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class ProductListInfo extends StatelessWidget {
  const ProductListInfo({
    Key? key,
    required this.includes,
  }) : super(key: key);

  final String includes;

  @override
  Widget build(BuildContext context) {
    final includesList = includes.split(',');
    final _utils = Utils.instance;
    return Expanded(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          itemCount: includesList.length,
          itemBuilder: (context, index) => Padding(
            padding:
                EdgeInsets.symmetric(vertical: _utils.getHeightPercent(.017)),
            child: Row(
              children: [
                Icon(Icons.check),
                Container(
                  width: _utils.getWidthPercent(.8),
                  child: Text(
                    '${includesList[index]}',
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
