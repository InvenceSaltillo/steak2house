import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/screens/credit_cards/my_credit_cards/my_credit_cards.dart';
import 'package:steak2house/src/screens/home/widgets/menu_item.dart';
import 'package:steak2house/src/services/auth_service.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'drawer_user_avatar.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<MenuItem> mainMenu = [
      MenuItem("Inicio", Icons.home_outlined, 0),
      MenuItem("Mis pedidos", Icons.shopping_basket_outlined, 1),
      // MenuItem("Mi perfil", Icons.settings, -1),
      MenuItem("Favoritos", Icons.favorite_border, 2),
      MenuItem("Carrito", Icons.shopping_cart_outlined, 3),
      // MenuItem("Notificaciones", Icons.notifications, 4),
      MenuItem("Tarjetas", Icons.credit_card, 4),
      // MenuItem("Acerca de nosotros", Icons.info_outline, 4),
    ];

    final TextStyle androidStyle = const TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
    final TextStyle iosStyle = const TextStyle(color: Colors.white);
    final style = Platform.isAndroid ? androidStyle : iosStyle;
    final widthBox = SizedBox(
      width: 16.0,
    );
    var maskFormatter = new MaskTextInputFormatter(mask: '(###) ###-##-##');

    final _utils = Utils.instance;
    final _userCtrl = Get.find<UserController>();

    final bottomNavCtrl = Get.find<BottomNavigationBarController>();
    return Obx(
      () => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kPrimaryColor,
                Colors.indigo,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DraweUserAvatar(),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 36.0,
                      left: 24.0,
                      right: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userCtrl.user.value.name!,
                          style: TextStyle(
                            fontSize: _utils.getHeightPercent(.03),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _userCtrl.user.value.email!,
                          style: TextStyle(
                            fontSize: _utils.getHeightPercent(.017),
                            color: Colors.white.withOpacity(.5),
                          ),
                        ),
                        Text(
                          maskFormatter.maskText(_userCtrl.user.value.tel!),
                          style: TextStyle(
                            fontSize: _utils.getHeightPercent(.017),
                            color: Colors.white.withOpacity(.5),
                          ),
                        ),
                        Text(
                          'Versión ${_userCtrl.version.value}',
                          style: TextStyle(
                            fontSize: _utils.getHeightPercent(.017),
                            color: Colors.white.withOpacity(.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                      ),
                      child: Column(
                        children: [
                          ...mainMenu
                              .map(
                                (item) => MenuItemWidget(
                                  key: Key(item.index.toString()),
                                  item: item,
                                  callback: () {
                                    ZoomDrawer.of(context)!.toggle();

                                    switch (item.index!) {
                                      case -1:
                                        return Get.to(() => MyCreditCards());

                                      default:
                                    }
                                    bottomNavCtrl.pageCtrl.value
                                        .jumpToPage(item.index!);
                                    bottomNavCtrl.currentPage.value =
                                        item.index!;
                                  },
                                  widthBox: widthBox,
                                  style: style,
                                  selected: 1 == item.index,
                                ),
                              )
                              .toList(),
                          TextButton(
                            onPressed: () async {
                              await AuthService.auth.logOut();
                            },
                            style: TextButton.styleFrom(
                              primary: Color(0x44000000),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.logout,
                                  color: kSecondaryColor,
                                  size: 24,
                                ),
                                widthBox,
                                Expanded(
                                  child: Text(
                                    'Cerrar sesión',
                                    style: style,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
