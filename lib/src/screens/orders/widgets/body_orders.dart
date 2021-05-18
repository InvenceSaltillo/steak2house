import 'package:flutter/material.dart';

import 'package:steak2house/src/widgets/empty_results.dart';

class BodyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyResults(
      text: 'No tienes pedidos',
      svgSrc: 'assets/img/emptyOrders.svg',
    );
  }
}
