import 'package:flutter/material.dart';
import 'package:steak2house/src/widgets/empty_results.dart';

class BodyNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyResults(
      text: 'No tienes notificaciones',
      svgSrc: 'assets/img/emptyNotifications.svg',
    );
  }
}
