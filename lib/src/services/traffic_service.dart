import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

class TrafficService {
  TrafficService._internal();
  static TrafficService _instance = TrafficService._internal();
  static TrafficService get instance => _instance;

  final dio.Dio _dio = dio.Dio();

  final _locationCtrl = Get.find<LocationController>();

  // Map<String, String> headers = {
  //   'Content-Type': 'application/json;charset=UTF-8',
  //   'Charset': 'utf-8'
  // };

  final String urlTrafficMapbox =
      'https://api.mapbox.com/directions/v5/mapbox/driving';

  final riomarCoords = '-100.9933244,25.4114879';

  final String _mapboxApiKey =
      'pk.eyJ1IjoicmlvamFzIiwiYSI6ImNrbzJkMDNrejAwcncydnM3NTloejFvemcifQ.FpiH4pu45-huxa8PoPon8Q';

  Future<double> getDeliveryDistance() async {
    final currentLat =
        _locationCtrl.tempAddress.value.results![0].geometry!.location!.lat!;
    final currentLng =
        _locationCtrl.tempAddress.value.results![0].geometry!.location!.lng!;

    try {
      final response = await _dio.get(
          '$urlTrafficMapbox/$riomarCoords;$currentLng,$currentLat',
          queryParameters: {
            'alternatives': 'false',
            'geometries': 'polyline6',
            'steps': 'false',
            'access_token': _mapboxApiKey,
            'language': 'es'
          });

      final distance = response.data['routes'][0]['distance'] / 1000;

      return distance;
    } on dio.DioError catch (e) {
      if (e.response != null) {
        print('DIOERROR DATA===== ${e.response!.data}');
        print('DIOERROR HEADERS===== ${e.response!.headers}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE===== ${e.message}');
        Dialogs.instance.showSnackBar(
          DialogType.error,
          e.message,
          false,
        );
      }
      return -1.0;
    }
  }

  Future<List> getDeliveryTimes() async {
    final url = Utils.instance.urlBackend;

    try {
      final response = await _dio.get(
        '${url}delivery/deliveryTime',
      );

      print('getDeliveryTimes ${response.data['data']}');

      final times = response.data['data'] as List;
      return times;
    } on dio.DioError catch (e) {
      if (e.response != null) {
        print('DIOERROR DATA getDeliveryTimes===== ${e.response!.data}');
        print('DIOERROR HEADERS getDeliveryTimes===== ${e.response!.headers}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE getDeliveryTimes===== ${e.message}');
        Dialogs.instance.showSnackBar(
          DialogType.error,
          e.message,
          false,
        );
      }
      return [];
    }
  }

  Future<DateTime> getCurrentTime() async {
    final url = Utils.instance.urlBackend;

    try {
      final response = await _dio.get(
        '${url}delivery/getCurrentTime',
      );

      print('getCurrentTime ${response.data['data']}');

      final currentTime = response.data['data'];
      final dateTime = DateTime.parse(currentTime);
      return dateTime;
    } on dio.DioError catch (e) {
      if (e.response != null) {
        print('DIOERROR DATA getCurrentTime===== ${e.response!.data}');
        print('DIOERROR HEADERS getCurrentTime===== ${e.response!.headers}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE getCurrentTime===== ${e.message}');
        Dialogs.instance.showSnackBar(
          DialogType.error,
          e.message,
          false,
        );
      }
      return DateTime(1);
    }
  }
}
