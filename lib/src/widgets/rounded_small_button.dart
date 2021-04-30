import 'package:flutter/material.dart';

import '../utils/utils.dart';

class RoundedSmallButton extends StatelessWidget {
  const RoundedSmallButton({
    Key? key,
    required Utils utils,
    required this.width,
    required this.height,
    required this.icon,
    this.color = Colors.white,
    required this.onTap,
  })   : _utils = utils,
        super(key: key);

  final Utils _utils;
  final double width;
  final double height;
  final Widget icon;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        // splashColor: Colors.black12,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          alignment: Alignment.center,
          width: _utils.getWidthPercent(width),
          height: _utils.getWidthPercent(height),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: color,
          ),
          child: icon,
        ),
      ),
    );
  }
}
