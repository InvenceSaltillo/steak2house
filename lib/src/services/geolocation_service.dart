import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:steak2house/src/controllers/location_controller.dart';

import 'package:steak2house/src/models/geolocation_model.dart';

class GeolocationService {
  GeolocationService._internal();
  static GeolocationService _instance = GeolocationService._internal();
  static GeolocationService get instance => _instance;

  final dio.Dio _dio = dio.Dio();
  // ignore: close_sinks
  final StreamController<GeocodingResponse> _searchStreamCtrl =
      StreamController<GeocodingResponse>.broadcast();

  Stream<GeocodingResponse> get searchStream => _searchStreamCtrl.stream;

  Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8'
  };

  final String _urlGeocoding = 'https://api.mapbox.com/geocoding/v5';
  final String _urlGeocodingGoogleMaps =
      'https://maps.googleapis.com/maps/api/geocode/json';
  final String _mapboxApiKey =
      'pk.eyJ1IjoicmlvamFzIiwiYSI6ImNrbzJkMDNrejAwcncydnM3NTloejFvemcifQ.FpiH4pu45-huxa8PoPon8Q';

  final String _googleMapsApiKey = 'AIzaSyARKrExhQIPEKdYuU52SyWSZy94h-Y5fUA';

  final locationCtrl = Get.find<LocationController>();
  Timer _debounce = Timer(Duration(milliseconds: 500), () {});

  bool flagTempAddress = true;

  Future<void> reverseGeocoding(LatLng position, bool flag) async {
    print('FLAG $flagTempAddress');
    try {
      final response = await _dio.get(
        '$_urlGeocodingGoogleMaps?latlng=${position.latitude},${position.longitude}&key=$_googleMapsApiKey',
      );

      final resp = GeocodingResponse.fromJson(response.data);

      locationCtrl.currentStreet.value = resp.results![0].formattedAddress!;
      locationCtrl.currentAddress.value = resp;

      if (flag) {
        locationCtrl.tempAddress.value = locationCtrl.currentAddress.value;
        flag = false;
      }
    } catch (e) {
      // Dialogs.instance.dismiss();
      // productCtrl.loading.value = false;
      // return false;
    }
  }

  Future<GeocodingResponse> getResultsByQuery(
      String search, Position proximity) async {
    final url = '$_urlGeocoding/mapbox.places/$search.json';

    try {
      final response = await _dio.get(url, queryParameters: {
        'access_token': _mapboxApiKey,
        'autocomplete': true,
        'proximity': '${proximity.longitude},${proximity.latitude}',
        'language': 'es',
      });
      // print('BUSCANDO... ${response.data}');

      // if (!response.data) {
      //   return GeocodingResponse(results: []);
      // }
      // ignore: unused_local_variable
      final res = json.decode(response.data);
      final searchResponse = geocodingResponseFromJson(response.data);

      locationCtrl.searchResult.value = searchResponse;
      return searchResponse;
    } on dio.DioError catch (e) {
      if (e.response != null) {
        print('DIOERROR DATA===== ${e.response!.data}');
        print('DIOERROR HEADERS===== ${e.response!.headers}');
        return GeocodingResponse(results: []);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE===== ${e.message}');
      }
      locationCtrl.searchResult.value.results = [];
    }
    return GeocodingResponse(results: []);
  }

  debounce(String search, Position proximity) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getResultsByQuery(search, proximity);
    });
  }
}
