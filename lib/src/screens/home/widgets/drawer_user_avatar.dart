import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/screens/profile/profile_screen.dart';
import 'package:steak2house/src/utils/utils.dart';

class DraweUserAvatar extends StatelessWidget {
  DraweUserAvatar({
    Key? key,
  }) : super(key: key);

  final _utils = Utils.instance;
  final _userCtrl = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ProfileScreen());

        ZoomDrawer.of(context)!.toggle();
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: _utils.getHeightPercent(.05),
          bottom: _utils.getWidthPercent(.02),
          left: _utils.getWidthPercent(.04),
          right: _utils.getWidthPercent(.03),
        ),
        child: Stack(
          children: [
            Container(
              width: _utils.getWidthPercent(.25),
              height: _utils.getWidthPercent(.25),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/animations/loading.gif',
                  fit: BoxFit.cover,
                  image: _userCtrl.user.value.avatar!,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset(
                    'assets/img/noAvatar.png',
                    height: _utils.getHeightPercent(.1),
                    width: _utils.getHeightPercent(.1),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: _utils.getWidthPercent(.06),
                height: _utils.getWidthPercent(.06),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: kPrimaryColor,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: _utils.getWidthPercent(.04),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
