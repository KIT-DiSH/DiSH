import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinModel {
  final String id, restName;
  final List<String> imageUrls;
  final LatLng map;

  PinModel({
    required this.id,
    required this.restName,
    required this.imageUrls,
    required this.map,
  });
}
