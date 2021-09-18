import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckPlacesMap extends StatefulWidget {
  CheckPlacesMap({
    Key? key,
    required this.latLng,
  });
  final latLng;

  @override
  State<CheckPlacesMap> createState() => CheckPlacesMapState();
}

class CheckPlacesMapState extends State<CheckPlacesMap> {
  Completer<GoogleMapController> _controller = Completer();
  late CameraPosition currentPosition = CameraPosition(
    target: widget.latLng,
    // zoom: 17.0,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: currentPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: <Marker>[
          Marker(
            markerId: MarkerId("0"),
            position: widget.latLng,
          ),
          // Marker(
          //   markerId: MarkerId("1"),
          //   position: widget.latLng,
          // ),
        ].toSet(),
        myLocationEnabled: true,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.pop(context),
      //   child: Icon(Icons.check),
      // ),
    );
  }
}
