import 'dart:async';
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
  CameraPosition currentPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
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
            //
            markers.add(
              Marker(
                markerId: MarkerId(markers.length.toString()),
                position: widget.latLng!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ),
              ),
            );
          }
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
