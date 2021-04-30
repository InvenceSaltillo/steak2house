import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/user_model.dart';
import 'package:steak2house/src/services/auth_service.dart';
import 'package:steak2house/src/utils/utils.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<MenuItem> mainMenu = [
      MenuItem("Inicio", Icons.home_outlined, 0),
      MenuItem("Mis pedidos", Icons.shopping_basket_outlined, 1),
      // MenuItem("Mi perfil", Icons.settings, -1),
      MenuItem("Favoritos", Icons.favorite_border, 2),
      MenuItem("Carrito", Icons.shopping_cart_outlined, 3),
      MenuItem("Notificaciones", Icons.notifications, 4),
      MenuItem("Tarjetas", Icons.credit_card, -1),
      // MenuItem("Acerca de nosotros", Icons.info_outline, 4),
    ];

    final TextStyle androidStyle = const TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
    final TextStyle iosStyle = const TextStyle(color: Colors.white);
    final style = Platform.isAndroid ? androidStyle : iosStyle;
    final widthBox = SizedBox(
      width: 16.0,
    );

    final _utils = Utils.instance;
    final _userCtrl = Get.find<UserController>();
    final User _user = _userCtrl.user.value;

    final bottomNavCtrl = Get.find<BottomNavigationBarController>();
    return Scaffold(
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
                Padding(
                  padding: EdgeInsets.only(
                    top: _utils.getHeightPercent(.05),
                    bottom: _utils.getWidthPercent(.02),
                    left: _utils.getWidthPercent(.04),
                    right: _utils.getWidthPercent(.03),
                  ),
                  child: Container(
                    width: _utils.getWidthPercent(.25),
                    height: _utils.getWidthPercent(.25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/animations/loading.gif',
                        fit: BoxFit.cover,
                        image: _user.avatar!,
                      ),
                    ),
                  ),
                ),
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
                        _user.name!,
                        style: TextStyle(
                          fontSize: _utils.getHeightPercent(.03),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _user.email!,
                        style: TextStyle(
                          fontSize: _utils.getHeightPercent(.017),
                          color: Colors.white.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // height: _utils.getHeightPercent(.5),
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
                                  if (item.index < 0) {}
                                  bottomNavCtrl.pageCtrl.value
                                      .jumpToPage(item.index);
                                  bottomNavCtrl.currentPage.value = item.index;
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
                        )
                      ],
                    ),
                  ),
                ),
                // Container(
                //   width: double.infinity,
                //   height: 100,
                //   decoration: BoxDecoration(
                //     color: Colors.orange,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem? item;
  final Widget? widthBox;
  final TextStyle? style;
  final Function()? callback;
  final bool? selected;

  final white = Colors.white;

  const MenuItemWidget({
    Key? key,
    this.item,
    this.widthBox,
    this.style,
    this.callback,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: callback,
      style: TextButton.styleFrom(
        primary: selected! ? Color(0x44000000) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            item!.icon,
            color: kSecondaryColor,
            size: 24,
          ),
          widthBox!,
          Expanded(
            child: Text(
              item!.title,
              style: style,
            ),
          )
        ],
      ),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final int index;

  const MenuItem(this.title, this.icon, this.index);
}
