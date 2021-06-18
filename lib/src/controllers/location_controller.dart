import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:steak2house/src/models/geolocation_model.dart';
import 'package:steak2house/src/services/geolocation_service.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';

class LocationController extends GetxController {
  var permissionStatus = PermissionStatus.denied.obs;
  var fromSettings = false.obs;
  var isLocationEnabled = false.obs;
  var currentStreet = ''.obs;
  var currentPosition = Position(
    longitude: 0.0,
    latitude: 0.0,
    timestamp: null,
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  ).obs;
  var searchResult = GeocodingResponse().obs;

  var currentAddress = GeocodingResponse().obs;
  var tempAddress = GeocodingResponse().obs;

  var newLat = 0.0;
  var newLng = 0.0;

  var deliveryRange = 4000.0.obs;
  var outOfRange = false.obs;

  RxList<GeocodingResponse> addressesList = RxList<GeocodingResponse>();

  Future<PermissionStatus> requestPermission() async {
    permissionStatus.value = await Permission.location.request();
    return permissionStatus.value;
  }

  Future<bool> checkLocationEnabled() async {
    isLocationEnabled.value = await Geolocator.isLocationServiceEnabled();
    return isLocationEnabled.value;
  }

  Future<Position> getCurrentPosition(bool flag) async {
    currentPosition.value = await Geolocator.getCurrentPosition();
    final newCurrentPosition =
        LatLng(currentPosition.value.latitude, currentPosition.value.longitude);
    GeolocationService.instance.reverseGeocoding(newCurrentPosition, flag);

    print('getCurrentPosition ${currentPosition.value.latitude}');

    newLat = currentPosition.value.latitude;
    newLng = currentPosition.value.longitude;

    return currentPosition.value;
  }

  Future<void> getAddressesList() async {
    try {
      final addresses = await SharedPrefs.instance.getKey('addresses') as List;

      final List<GeocodingResponse> myAddressesList = addresses
          .map((address) => new GeocodingResponse.fromJson(address))
          .toList();
      addressesList.value = myAddressesList;
    } catch (e) {
      print('ERRORRRR========= ');
    }
  }

  @override
  void onReady() async {
    await getAddressesList();
    super.onReady();
  }
}
