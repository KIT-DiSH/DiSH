import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dish/plugins/simple_log_printer.dart';

class Places {
  final String businessStatus;
  final Map<String, dynamic> geometry;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;
  final String name;
  final Map<String, dynamic> openingHours;
  final List<dynamic> photos;
  final String placeId;
  final Map<String, dynamic> plusCode;
  final double rating;
  final String reference;
  final String scope;
  final List<dynamic> types;
  final int userRatingsTotal;
  final String vicinity;

  Places(
      this.businessStatus,
      this.geometry,
      this.icon,
      this.iconBackgroundColor,
      this.iconMaskBaseUri,
      this.name,
      this.openingHours,
      this.photos,
      this.placeId,
      this.plusCode,
      this.rating,
      this.reference,
      this.scope,
      this.types,
      this.userRatingsTotal,
      this.vicinity);

  Places.fromJson(Map<String, dynamic> json)
      : businessStatus = json['business_status'],
        geometry = json['geometry'],
        icon = json['icon'],
        iconBackgroundColor = json['icon_background_color'],
        iconMaskBaseUri = json['icon_mask_base_uri'],
        name = json['name'],
        openingHours = json['opening_hours'],
        photos = json['photos'],
        placeId = json['place_id'],
        plusCode = json['plus_code'],
        rating = json['rating'],
        reference = json['reference'],
        scope = json['scope'],
        types = json['types'],
        userRatingsTotal = json['user_ratings_total'],
        vicinity = json['vicinity'];
}

Future<Places> execPlacesAPI({
  required LatLng latlng,
  int radius = 100,
  String type = "restaurant",
  String language = "ja",
}) async {
  final logger = Logger(printer: SimpleLogPrinter('PlacesAPI'));
  String apiKey = dotenv.env['PLACES_API_KEY']!;

  var url =
      Uri.https("maps.googleapis.com", "/maps/api/place/nearbysearch/json", {
    "location": "${latlng.latitude},${latlng.longitude}",
    "radius": radius.toString(),
    "type": type,
    "language": language,
    "pagetoken": 10,
    "key": apiKey,
  });
  logger.i('Searching nearby places with provided coordinate');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var json = response.body;
    Map<String, dynamic> placesMap = jsonDecode(json);
    Places places = new Places.fromJson(placesMap['results'][0]);
    return places;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    throw new Error();
  }
}
