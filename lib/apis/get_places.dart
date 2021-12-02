import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dish/plugins/simple_log_printer.dart';

class PlaceDetail {
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

  PlaceDetail(
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

  PlaceDetail.fromJson(Map<String, dynamic> json)
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

class Place {
  final Map<String, dynamic> geometry;
  final String? icon;
  final String name;
  final List<dynamic>? photos;
  final String placeId;

  Place(
    this.geometry,
    this.icon,
    this.name,
    this.photos,
    this.placeId,
  );

  Place.fromJson(Map<String, dynamic> json)
      : geometry = json['geometry'],
        icon = json['icon'],
        name = json['name'],
        photos = json['photos'],
        placeId = json['place_id'];
}

bool checkValue(place) {
  if (place['geometry'] == null ||
      place['icon'] == null ||
      place['name'] == null ||
      place['photos'] == null ||
      place['place_id'] == null) return false;
  return true;
}

Future<List<Place>> execPlacesAPI({
  required LatLng latlng,
  int radius = 500,
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
    "key": apiKey,
  });
  logger.i('Searching nearby places with provided coordinate');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var json = response.body;
    Map<String, dynamic> placesMap = jsonDecode(json);
    if (placesMap["status"] == "ZERO_RESULTS") return [];
    if (placesMap["status"] != "OK") throw new Error();
    List<Place> places = [];
    int placeCount = 0;
    for (var place in (placesMap['results'] as List)) {
      if (placeCount >= 10) break;
      if (checkValue(place)) places.add(new Place.fromJson(place));
      placeCount++;
    }

    return places;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    throw new Error();
  }
}
