import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:steak2house/themes/map_theme.dart';

class MapController extends GetxController {
  var mapReady = false.obs;
  late GoogleMapController mapController;
  var centerLocation = LatLng(0.0, 0.0).obs;

  void initMap(GoogleMapController controller) {
    if (mapReady.value) {
      mapController = controller;
      mapReady.value = true;
      mapController.setMapStyle(json.encode(mapTheme));
    }
  }

  void moveCamera(LatLng destiny) {
    final cameraUpdate = CameraUpdate.newLatLng(destiny);
    mapController.animateCamera(cameraUpdate);
  }
}
