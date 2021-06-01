import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/screens/sign_in/widgets/button_social.dart';
import 'package:steak2house/src/services/auth_service.dart';

class BodySignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = Get.size;
    final _miscCtrl = Get.find<MiscController>();
    if (_miscCtrl.errorMessage.value != '') {
      showError(_miscCtrl);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          child: Hero(
            tag: 'splashImg',
            child: SvgPicture.asset(
              'assets/img/steak.svg',
              width: size.width * .5,
            ),
          ),
        ),
        SizedBox(height: size.height * .03),
        Column(
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * .1,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'STEAK',
                  ),
                  TextSpan(
                    text: '2',
                    style: TextStyle(
                      fontSize: size.width * .18,
                      color: Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: 'HOUSE',
                  )
                ],
              ),
            ),
            SizedBox(height: size.height * .03),
            Text(
              '¡Aquí comienza la carne asada!',
              style: TextStyle(
                color: Colors.black38,
                fontSize: size.width * .05,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: size.height * .03),
            // ButtonSocial(
            //   onPressed: () async {
            //     await AuthService.auth.googleLogin();
            //   },
            //   text: 'Google',
            //   color: Color(0xffDB4437),
            //   icon: FaIcon(FontAwesomeIcons.google),
            // ),
            SizedBox(height: size.height * .03),
            ButtonSocial(
              onPressed: () async {
                await AuthService.auth.facebookLogin();
              },
              text: 'Facebook',
              color: Color(0xff4267B2),
              icon: FaIcon(FontAwesomeIcons.facebookF),
            ),
            // SizedBox(height: size.height * .03),
            // ButtonSocial(
            //   onPressed: () {
            //     AuthService.auth.appleLogin();
            //   },
            //   text: 'Apple',
            //   color: Color(0xff000000),
            //   icon: FaIcon(FontAwesomeIcons.apple),
            // ),
            SizedBox(height: size.height * .03),
            Text(
              'Ingresa con tus redes sociales.',
              style: TextStyle(
                color: Colors.black38,
                fontSize: size.width * .05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void showError(MiscController controller) async {
  await Future.delayed(Duration(milliseconds: 250));

  controller.showErrorServerSnackBar();
  controller.errorMessage.value = '';
}
