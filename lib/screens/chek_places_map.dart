import 'dart:async';
import 'package:dish/dummy/dummy_places.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:dish/models/PostModel.dart';

class CheckPlacesMap extends StatefulWidget {
  CheckPlacesMap({
    Key? key,
    this.latLng,
  });
  // のちにお店に修正
  final LatLng? latLng;

  @override
  State<CheckPlacesMap> createState() => CheckPlacesMapState();
}

class CheckPlacesMapState extends State<CheckPlacesMap> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];
  // todo: initStateで変更した場所にカメラをフォーカス
  late CameraPosition currentPosition = CameraPosition(
    target: LatLng(
      33.590188,
      130.420685,
    ),
    zoom: 15,
  );

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
          if (widget.latLng != null) {
            markers.add(
              Marker(
                markerId: MarkerId(markers.length.toString()),
                position: widget.latLng!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ),
              ),
            );
            currentPosition = CameraPosition(
              target: widget.latLng!,
              zoom: 15,
            );
          }
          // a@c.com
          for (PostModel post in posts) {
            // todo: 後々同じお店のIDなら弾くように変更
            if (widget.latLng != null && widget.latLng == post.map) continue;
            markers.add(
              Marker(
                markerId: MarkerId(markers.length.toString()),
                position: post.map,
              ),
            );
          }
          for (int i = 0; i < dummyPlaces.length; i++) {
            markers.add(
              Marker(
                markerId: MarkerId((markers.length + i + 1).toString()),
                position: dummyPlaces[i],
              ),
            );
          }
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
            markers: markers.toSet(),
            myLocationEnabled: true,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
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
    );
  }
}
