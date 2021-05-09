import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../../../constants.dart';

class BodyNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/img/emptyNotifications.svg',
            width: _utils.getWidthPercent(.7),
          ),
          Text(
            'No tienes notificaciones',
            style: TextStyle(
              fontSize: _utils.getHeightPercent(.025),
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
