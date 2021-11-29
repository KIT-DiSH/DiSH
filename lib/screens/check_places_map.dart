import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish/dummy/dummy_places.dart';
import 'package:dish/models/User.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:dish/models/PostModel.dart';
import 'package:intl/intl.dart';

class CheckPlacesMap extends StatefulWidget {
  CheckPlacesMap({
    Key? key,
    required this.latLng,
    this.uid,
  });
  // のちにお店に修正
  final LatLng latLng;
  final String? uid;

  @override
  State<CheckPlacesMap> createState() => CheckPlacesMapState();
}

class CheckPlacesMapState extends State<CheckPlacesMap> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];
  // todo: initStateで変更した場所にカメラをフォーカス
  CameraPosition? currentPosition;

  Stream<Map<String, dynamic>>? timeline;

  @override
  initState() {
    super.initState();
    setState(
      () {
        currentPosition = CameraPosition(
          target: widget.latLng,
          zoom: 15,
        );
        // 新しいフラグを考える必要あり
        if (widget.uid != null) {
          markers.add(
            Marker(
              markerId: MarkerId(markers.length.toString()),
              position: widget.latLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ),
          );
          currentPosition = CameraPosition(
            target: widget.latLng,
            zoom: 15,
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
        for (int i = 0; i < dummyPlaces.length; i++) {
          markers.add(
            Marker(
              markerId: MarkerId((markers.length + i + 1).toString()),
              position: dummyPlaces[i],
            ),
          );
        }
      },
    );
  }

  // Future<Map<String, dynamic>> _generateDiSHPost(
  //     QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
  //   Map<String, dynamic> data = doc.data();
  //   User user = await _getUser(data["uid"]);
  //   PostModel postInfo = PostModel(
  //     id: "item.id",
  //     content: data["content"],
  //     restName: data["restaurant_name"],
  //     // タグの扱いは後ほど考え直す必要あり
  //     tags: "#ムリぽ",
  //     imageUrls: data["image_paths"].cast<String>() as List<String>,
  //     postUser: user,
  //     date: DateFormat("yyyy/MM/dd").format(data["timestamp"].toDate()),
  //     favoUsers: [],
  //     comments: [],
  //     map: LatLng(
  //       data["location"]["lat"] + 0.0,
  //       data["location"]["lng"] + 0.0,
  //     ),
  //     stars: {
  //       "cost": data["evaluation"]["cost"] + 0.0,
  //       "mood": data["evaluation"]["mood"] + 0.0,
  //       "taste": data["evaluation"]["taste"] + 0.0,
  //     },
  //   );
  //   return new Map<String, dynamic>.from(
  //       {"uid": data["uid"], "postInfo": postInfo});
  // }

  // Future<User> _getUser(String uid) async {
  //   DocumentReference userRef =
  //       FirebaseFirestore.instance.collection("USERS").doc(uid);
  //   DocumentSnapshot snapshot = await userRef.get();

  //   if (!snapshot.exists) {
  //     print("💣 Something went wrong");
  //   }

  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   User user = User(
  //     userId: data["user_id"],
  //     userName: data["user_name"],
  //     profileText: data["profile_text"],
  //     iconImageUrl: data["icon_path"],
  //   );
  //   return user;
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: currentPosition!,
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
