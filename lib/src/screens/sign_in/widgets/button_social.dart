import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/utils.dart';

class ButtonSocial extends StatelessWidget {
  final FaIcon icon;
  final String text;
  final Color color;
  final void Function() onPressed;
  const ButtonSocial({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        text,
        style: TextStyle(
          fontSize: _utils.getWidthPercent(.05),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: color,
        primary: Colors.white,
        shape: StadiumBorder(),
        padding: EdgeInsets.all(10.0),
        minimumSize: Size(_utils.getWidthPercent(.8), 10),
      ),
    );
  }
}
