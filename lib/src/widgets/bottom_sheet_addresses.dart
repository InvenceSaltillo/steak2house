import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/controllers/map_controller.dart';
import 'package:steak2house/src/models/geolocation_model.dart';
import 'package:steak2house/src/services/geolocation_service.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/search_text_field.dart';

class BottomSheetAddresses extends StatelessWidget {
  BottomSheetAddresses({
    Key? key,
  }) : super(key: key);

  final Utils _utils = Utils.instance;
  final _locationCtrl = Get.find<LocationController>();
  final _mapCtrl = Get.find<MapController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: _utils.getHeightPercent(.9),
        // height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.clear),
                )
              ],
            ),
            Text(
              'Confirma tu ubicación',
              style: TextStyle(
                fontSize: _utils.getHeightPercent(.038),
                fontWeight: FontWeight.bold,
              ),
            ),
            Stack(
              children: [
                Container(
                  height: _utils.getHeightPercent(.5),
                  child: Stack(
                    children: [
                      buildMap(),
                      Center(
                        child: Transform.translate(
                          offset: Offset(0, -15),
                          child: BounceInDown(
                            from: 200,
                            child: Icon(
                              Icons.location_on,
                              size: _utils.getHeightPercent(.05),
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      )
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
            ),
            Text('Direccion: ${_locationCtrl.currentStreet.value}'),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: _utils.getWidthPercent(.06),
            //     vertical: _utils.getHeightPercent(.03),
            //   ),
            //   child: SearchTextField(
            //     onChanged: (value) async {
            //       _locationCtrl.searchResult.value.features = [];
            //       GeolocationService.instance
            //           .debounce(value, _locationCtrl.currentPosition.value);
            //     },
            //     onSubmitted: (value) async {
            //       print(value);
            //     },
            //     controller: _controller,
            //     icon: Icons.location_on_outlined,
            //     hintText: 'Escribe una dirección',
            //   ),
            // ),
            // Obx(
            //   () => Expanded(
            //     child: _locationCtrl.searchResult.value.features == null
            //         ? ListTile(
            //             leading: Icon(Icons.location_searching),
            //             title: Text('Ubicación Actual'),
            //             subtitle: Text(_locationCtrl.currentStreet.value),
            //             onTap: () {},
            //           )
            //         : _locationCtrl.searchResult.value.features!.length == 0
            //             ? Center(child: Text('No hay resultados para mostrar'))
            //             : ListView.separated(
            //                 physics: BouncingScrollPhysics(),
            //                 itemCount:
            //                     _locationCtrl.searchResult.value.features!.length,
            //                 padding: EdgeInsets.zero,
            //                 itemBuilder: (context, index) {
            //                   final place = _locationCtrl
            //                       .searchResult.value.features![index];
            //                   return ListTile(
            //                     leading: Icon(Icons.location_on_outlined),
            //                     title: Text(place.textEs),
            //                     subtitle: Text(place.placeNameEs),
            //                     onTap: () {
            //                       print(place.textEs);
            //                     },
            //                   );
            //                 },
            //                 separatorBuilder: (_, int index) => Divider(
            //                   height: 1,
            //                   color: kPrimaryColor,
            //                 ),
            //               ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget buildMap() {
    final _mapCtrl = Get.find<MapController>();
    final initialCameraPosition = CameraPosition(
      target: LatLng(_locationCtrl.currentPosition.value.latitude,
          _locationCtrl.currentPosition.value.longitude),
      zoom: 15,
    );

    CameraPosition _cameraPosition = CameraPosition(target: LatLng(0.0, 0.0));
    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        print('CONTROLLER');
        _mapCtrl.mapReady.value = true;
        _mapCtrl.initMap(controller);
      },
      onCameraMove: (CameraPosition cameraPosition) {
        print('MoveCamera');
        _cameraPosition = cameraPosition;
      },
      onCameraIdle: () {
        _mapCtrl.centerLocation.value = _cameraPosition.target;
        print('POSITION ${_mapCtrl.centerLocation.value}');
        final LatLng position = _cameraPosition.target;
        GeolocationService.instance.reverseGeocoding(position);
      },
    );
  }
}
