import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/services/payment_service.dart';

import '../../../constants.dart';
import 'widgets/my_credit_cards_body.dart';

class MyCreditCards extends StatefulWidget {
  @override
  _MyCreditCardsState createState() => _MyCreditCardsState();
}

class _MyCreditCardsState extends State<MyCreditCards> {
  @override
  void initState() {
    // final _paymentCtrl = Get.find<PaymentController>();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // if (_paymentCtrl.cardsList.length == 0) {
      //   PaymentService.instance.getConektaCustomer();
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //     icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor),
      //   ),
      //   title: Text(
      //     'Tarjetas guardadas',
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      body: MyCreditCardsBody(),
    );
  }
}
