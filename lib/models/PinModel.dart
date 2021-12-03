import 'package:dish/models/User.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinModel {
  final String id, restName;
  final List<String> imageUrls;
  final LatLng map;
  final User user;

  PinModel({
    required this.id,
    required this.restName,
    required this.imageUrls,
    required this.map,
    required this.user,
  });
}
