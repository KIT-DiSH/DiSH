import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapSpecifyPin extends StatefulWidget {
  @override
  State<MapSpecifyPin> createState() => MapSpecifyPinState();
}

class MapSpecifyPinState extends State<MapSpecifyPin> {
  Completer<GoogleMapController> _controller = Completer();
  late CameraPosition currentPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  LatLng pinLatLng = LatLng(37.42796133580664, -122.085749655962);

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
      body: GoogleMap(
        mapType: MapType.hybrid,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ピンの座標からお店を取得する処理
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
