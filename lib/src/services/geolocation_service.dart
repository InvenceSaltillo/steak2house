import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:steak2house/src/controllers/location_controller.dart';

import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/models/geolocation_model.dart';
import 'package:steak2house/src/models/product_model.dart';
import 'package:steak2house/src/utils/debouncer.dart';
import 'package:steak2house/src/utils/utils.dart';

class GeolocationService {
  GeolocationService._internal();
  static GeolocationService _instance = GeolocationService._internal();
  static GeolocationService get instance => _instance;

  final dio.Dio _dio = dio.Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 2000));
  final StreamController<GeocodingResponse> _searchStreamCtrl =
      StreamController<GeocodingResponse>.broadcast();

  Stream<GeocodingResponse> get searchStream => _searchStreamCtrl.stream;

  Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8'
  };

  final String _urlGeocoding = 'https://api.mapbox.com/geocoding/v5';
  final String _mapboxApiKey =
      'pk.eyJ1IjoicmlvamFzIiwiYSI6ImNrbzJkMDNrejAwcncydnM3NTloejFvemcifQ.FpiH4pu45-huxa8PoPon8Q';

  final locationCtrl = Get.find<LocationController>();
  Timer _debounce = Timer(Duration(milliseconds: 500), () {});

  Future<void> reverseGeocoding(LatLng position) async {
    // dio.FormData _data = dio.FormData.fromMap({
    //   "categoryId": categoryId,
    // });

    try {
      final response = await _dio.get(
        '$_urlGeocoding/mapbox.places/${position.longitude},${position.latitude}.json?access_token=$_mapboxApiKey',
      );

      final resp = json.decode(response.data);

      // print('RESPONSE ${resp['features'][0]['text']}');
      locationCtrl.currentStreet.value = resp['features'][0]['text'];
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
      //   return GeocodingResponse(features: []);
      // }
      final res = json.decode(response.data);
      print('GEORESPONSE====== ${res['features'][1]}');
      print('GEORESPONSE LENGTH====== ${res['features'].length}');
      final searchResponse = geocodingResponseFromJson(response.data);

      locationCtrl.searchResult.value = searchResponse;
      return searchResponse;
    } on dio.DioError catch (e) {
      if (e.response != null) {
        print('DIOERROR DATA===== ${e.response!.data}');
        print('DIOERROR HEADERS===== ${e.response!.headers}');
        return GeocodingResponse(features: []);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE===== ${e.message}');
      }
      locationCtrl.searchResult.value.features = [];
    }
    return GeocodingResponse(features: []);
  }

  debounce(String search, Position proximity) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getResultsByQuery(search, proximity);
    });
  }
}
