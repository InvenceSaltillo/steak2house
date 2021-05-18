import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/screens/credit_card/widgets/body_credit_card.dart';

class CreditCardScreen extends StatelessWidget {
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
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BodyCreditCard(),
    );
  }
}
