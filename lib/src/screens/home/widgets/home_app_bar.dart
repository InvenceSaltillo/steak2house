import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/controllers/map_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/user/user_model.dart';
import 'package:steak2house/src/screens/profile/profile_screen.dart';
import 'package:steak2house/src/widgets/dialogs.dart';
import '../../../utils/utils.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _HomeAppBarState extends State<HomeAppBar>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final locationCtrl = Get.find<LocationController>();

  late AnimationController animationController;
  bool isPlaying = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
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
    print('checkLocationAndGPS========= ');
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
      print('checkLocationAndGPS========= ');
      await locationCtrl.getCurrentPosition(true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState $state');

    if (state == AppLifecycleState.resumed) {
      print('OBTENIENDO UBICACION========');
      if (locationCtrl.permissionStatus.value == PermissionStatus.granted &&
          locationCtrl.isLocationEnabled.value) {
        await locationCtrl.getCurrentPosition(true);
      }

      final checkLocationEnabled = await locationCtrl.checkLocationEnabled();
      print('checkLocationEnabled $checkLocationEnabled');

      print('permissionStatus===== ${locationCtrl.permissionStatus.value} ');
      if (locationCtrl.fromSettings.value && checkLocationEnabled) {
        print('CUMPLEEEEEEEEE===== ');
        await locationCtrl.getCurrentPosition(true);
      }
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
            setState(() {
              isPlaying = !isPlaying;
              isPlaying
                  ? animationController.forward()
                  : animationController.reverse();
            });
            ZoomDrawer.of(context)!.toggle();
          },
          icon: Icon(
            Icons.menu,
            color: kPrimaryColor,
          ),
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
                width: _utils.getWidthPercent(.38),
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
          // Container(
          //   width: 100,
          //   height: 100,
          //   decoration: BoxDecoration(
          //     color: Colors.red,
          //     borderRadius: BorderRadius.circular(50),
          //   ),
          // ),
          TextButton(
            onPressed: () async {
              Get.to(() => ProfileScreen());
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Container(
                  width: _utils.getWidthPercent(.09),
                  height: _utils.getWidthPercent(.09),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/animations/loading.gif',
                    fit: BoxFit.cover,
                    image: _user.avatar!,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Image.asset(
                      'assets/img/noAvatar.png',
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
