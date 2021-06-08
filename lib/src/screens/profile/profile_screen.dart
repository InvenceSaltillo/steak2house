import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/screens/profile/widgets/profile_body.dart';

import '../../constants.dart';

class ProfileScreen extends StatelessWidget {
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
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      body: ProfileBody(),
    );
  }
}
