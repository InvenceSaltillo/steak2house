import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';

import 'package:steak2house/src/screens/sign_in/widgets/body_sign_in.dart';

class SignInScreen extends StatelessWidget {
  static final routeName = '/sign-in';

  @override
  Widget build(BuildContext context) {
    Get.put(MiscController());
    return Scaffold(
      body: BodySignIn(),
    );
  }
}
