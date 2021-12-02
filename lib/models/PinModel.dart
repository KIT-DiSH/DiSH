import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinModel {
  final String restName;
  final List<String> imageUrls;
  final LatLng map;

  PinModel({
    required this.restName,
    required this.imageUrls,
    required this.map,
  });
}
