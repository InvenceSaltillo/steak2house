import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../constants.dart';

class EmptyResults extends StatelessWidget {
  EmptyResults({
    Key? key,
    required this.text,
    required this.svgSrc,
  }) : super(key: key);

  final Utils _utils = Utils.instance;
  final String text;
  final String svgSrc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgSrc,
            width: _utils.getWidthPercent(.7),
            placeholderBuilder: (_) => LottieBuilder.asset(
              'assets/animations/loading.json',
              width: _utils.getWidthPercent(.5),
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
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
