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
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
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
            ].toSet(),
            myLocationEnabled: true,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
