import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:dish/apis/get_places.dart';

class SpecifyPinMap extends StatefulWidget {
  final LatLng currentLatLng;
  SpecifyPinMap({Key? key, required this.currentLatLng}) : super(key: key);

  @override
  State<SpecifyPinMap> createState() => SpecifyPinMapState();
}

class SpecifyPinMapState extends State<SpecifyPinMap> {
  Completer<GoogleMapController> _controller = Completer();
  late CameraPosition currentPosition = CameraPosition(
    target: widget.currentLatLng,
    zoom: 14.4746,
  );

  late LatLng pinLatLng = widget.currentLatLng;

  @override
  initState() {
    super.initState();
    Position position;
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (posi) {
        setState(() {
          position = posi;
          currentPosition = CameraPosition(
            target: LatLng(
              position.latitude,
              position.longitude,
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: currentPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (LatLng latLng) {
              setState(() {
                pinLatLng = latLng;
              });
            },
            markers: <Marker>[
              Marker(
                markerId: MarkerId("0"),
                position: pinLatLng,
                draggable: true,
                onDragEnd: (LatLng latLng) {
                  pinLatLng = latLng;
                },
              ),
            ].toSet(),
            myLocationEnabled: true,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                heroTag: "hero2",
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          heroTag: "hero1",
          onPressed: () async {
            List<Place> places = [];
            try {
              places = await execPlacesAPI(latlng: pinLatLng);
            } catch (e) {
              print("エラーが発生しました");
              print(e);
            }
            Navigator.pop(context, places);
          },
          child: Icon(Icons.check),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
