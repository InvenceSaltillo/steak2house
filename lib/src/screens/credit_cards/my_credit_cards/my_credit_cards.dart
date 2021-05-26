import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import 'widgets/my_credit_cards_body.dart';

class MyCreditCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor),
        ),
        title: Text(
          'Tarjetas guardadas',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: MyCreditCardsBody(),
    );
  }
}
