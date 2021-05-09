import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/user_model.dart';
import 'package:steak2house/src/screens/main/main_screen.dart';
import 'package:steak2house/src/screens/sign_in/sign_in_screen.dart';
import 'package:steak2house/src/services/auth_service.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

import '../../utils/utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AnimationController? _animateController;

  @override
  void initState() {
    checkIfIsLogged();
    super.initState();
  }

  void checkIfIsLogged() async {
    Get.put(UserController());
    Get.put(BottomNavigationBarController());
    Get.put(MiscController());
    Get.put(LocationController());
    Get.put(CartController());

    await Future.delayed(Duration(seconds: 1));
    final isFacebookLogged = await AuthService.auth.checkIfIsLogged();

    _animateController!.reverse(from: 1.0);
    await Future.delayed(Duration(seconds: 2));

    if (isFacebookLogged) {
      try {
        final userInfo = await SharedPrefs.instance.getKey('user');
        final userCtrl = Get.find<UserController>();

        final User user = userCtrl.user.value = User.fromJson(userInfo);

        Dialogs.instance.showSnackBar(
          DialogType.success,
          '¡Qué gusto verte de nuevo ${user.name}!',
          false,
        );

        await Future.delayed(Duration(milliseconds: 1500));

        Get.offUntil(
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return MainScreen();
            },
            transitionDuration: Duration(milliseconds: 800),
          ),
          (route) => false,
        );
      } catch (e) {
        print('ERRORRRR========= No hay info del usuario en SharedPrefs');
        Get.offUntil(
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return SignInScreen();
            },
            transitionDuration: Duration(milliseconds: 800),
          ),
          (route) => false,
        );
      }
    } else {
      Get.offUntil(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return SignInScreen();
          },
          transitionDuration: Duration(milliseconds: 800),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: FadeIn(
        controller: (controller) => _animateController = controller,
        duration: Duration(milliseconds: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Hero(
                tag: 'splashImg',
                child: SvgPicture.asset(
                  'assets/img/steak.svg',
                  width: _utils.getWidthPercent(.5),
                ),
              ),
            ),
            Lottie.asset(
              'assets/animations/loading.json',
              width: _utils.getWidthPercent(.3),
              height: _utils.getWidthPercent(.3),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FadeIn(
        controller: (controller) => _animateController = controller,
        duration: Duration(milliseconds: 1000),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _utils.getWidthPercent(.05),
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'STEAK',
                    ),
                    TextSpan(
                      text: '2',
                      style: TextStyle(
                        fontSize: _utils.getWidthPercent(.08),
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: 'HOUSE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _utils.getWidthPercent(.05),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
