import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/controllers/map_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/user/user_model.dart';
import 'package:steak2house/src/services/auth_service.dart';
import 'package:steak2house/src/services/payment_service.dart';
import 'package:steak2house/src/services/traffic_service.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

import '../../../utils/utils.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _HomeAppBarState extends State<HomeAppBar> with WidgetsBindingObserver {
  final locationCtrl = Get.find<LocationController>();
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    Get.put(MapController());
    checkLocationAndGPS();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Future<void> checkLocationAndGPS() async {
    await locationCtrl.requestPermission();
    await locationCtrl.checkLocationEnabled();

    if (!locationCtrl.isLocationEnabled.value) {
      return await Dialogs.instance.showLocationDialog(
        text: 'Por favor activa el GPS',
        gps: true,
      );
    }
    if (locationCtrl.permissionStatus.value != PermissionStatus.granted) {
      return Dialogs.instance.showLocationDialog(
        text: 'Necesitamos tu ubicación, por favor activala desde los ajustes',
        gps: false,
      );
    }

    if (locationCtrl.permissionStatus.value == PermissionStatus.granted &&
        locationCtrl.isLocationEnabled.value &&
        locationCtrl.currentPosition.value.latitude == 0.0) {
      final currentPosition = await locationCtrl.getCurrentPosition();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await locationCtrl.checkLocationEnabled();
      if (locationCtrl.permissionStatus.value == PermissionStatus.granted &&
          locationCtrl.isLocationEnabled.value) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;

    final _userCtrl = Get.find<UserController>();
    final User _user = _userCtrl.user.value;
    return Obx(
      () => AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
          icon: Icon(Icons.menu, color: kPrimaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: InkWell(
          onTap: () async {
            // locationCtrl.getCurrentPosition();
            Dialogs.instance.showLocationBottomSheet();
            // print(locationCtrl.currentAddress.value.results);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: kPrimaryColor,
              ),
              SizedBox(width: _utils.getWidthPercent(.01)),
              Container(
                width: _utils.getWidthPercent(.25),
                child: Text(
                  locationCtrl.tempAddress.value.results == null
                      ? 'Obteniendo ubicación'
                      : locationCtrl
                          .tempAddress.value.results![0].formattedAddress!,
                  overflow: TextOverflow.ellipsis,
                  // softWrap: true,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: _utils.getWidthPercent(.04),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: kPrimaryColor,
                ),
                padding: EdgeInsets.all(5),
                splashRadius: 12,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              PaymentService.instance.getConektaCustomer();
              // SharedPrefs.instance.deleteKey('lastUsedCard');
              // SharedPrefs.instance.deleteKey('cardList');
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Container(
                // padding: EdgeInsets.all(8),
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/animations/loading.gif',
                    fit: BoxFit.cover,
                    image: _user.avatar!,
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
            ),
          ),
        ],
      ),
    );
  }
}
