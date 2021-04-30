import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../utils/utils.dart';

class PorductReviewsPercent extends StatelessWidget {
  const PorductReviewsPercent({
    Key? key,
    required Utils utils,
  })   : _utils = utils,
        super(key: key);

  final Utils _utils;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: _utils.getWidthPercent(.25),
      height: _utils.getHeightPercent(.03),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(.9),
        borderRadius: BorderRadius.circular(3.5),
      ),
      child: Row(
        children: [
          SizedBox(width: _utils.getWidthPercent(.015)),
          Text(
            '4.5',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Icon(
            Icons.star,
            color: kSecondaryColor,
            size: _utils.getHeightPercent(.015),
          ),
          SizedBox(width: _utils.getWidthPercent(.025)),
          Text(
            '(40 Reviews)',
            style: TextStyle(
                color: Colors.white, fontSize: _utils.getWidthPercent(.025)),
          ),
        ],
      ),
    );
  }
}
