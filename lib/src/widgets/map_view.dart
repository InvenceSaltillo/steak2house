import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/controllers/map_controller.dart';
import 'package:steak2house/src/services/geolocation_service.dart';
import 'package:steak2house/src/services/traffic_service.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../constants.dart';
import 'dialogs.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mapCtrl = Get.find<MapController>();
    final _locationCtrl = Get.find<LocationController>();
    final initialCameraPosition = CameraPosition(
      target: LatLng(_locationCtrl.currentPosition.value.latitude,
          _locationCtrl.currentPosition.value.longitude),
      zoom: 13,
    );

    final _utils = Utils.instance;

    CameraPosition _cameraPosition = CameraPosition(target: LatLng(0.0, 0.0));
    Set<Circle> circles = Set.from(
      [
        Circle(
          circleId: CircleId('id'),
          center: LatLng(25.429947, -100.956762),
          radius: _locationCtrl.deliveryRange.value,
          fillColor: kPrimaryColor.withOpacity(0.3),
          strokeColor: Colors.transparent,
        )
      ],
    );

    return Stack(
      children: [
        Container(
          height: _utils.getHeightPercent(.45),
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCameraPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _mapCtrl.mapReady.value = true;
                  _mapCtrl.initMap(controller);
                },
                onCameraMove: (CameraPosition cameraPosition) {
                  _cameraPosition = cameraPosition;
                },
                onCameraIdle: () async {
                  _mapCtrl.centerLocation.value = _cameraPosition.target;
                  // await Future.delayed(Duration(seconds: 3));
                  final LatLng position = _cameraPosition.target;
                  GeolocationService.instance.reverseGeocoding(position, false);

                  _locationCtrl.newLat = position.latitude;
                  _locationCtrl.newLng = position.longitude;
                },
                circles: circles,
              ),
              Center(
                child: Transform.translate(
                  offset: Offset(0, -12),
                  child: BounceInDown(
                    from: 200,
                    child: Icon(
                      Icons.location_on,
                      size: _utils.getHeightPercent(.05),
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: SizedBox(
            width: _utils.getWidthPercent(.1),
            child: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: () {
                _mapCtrl.moveCamera(
                  LatLng(_locationCtrl.currentPosition.value.latitude,
                      _locationCtrl.currentPosition.value.longitude),
                );
              },
              child: Icon(
                Icons.location_searching,
                color: kSecondaryColor,
                size: _utils.getWidthPercent(.05),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
