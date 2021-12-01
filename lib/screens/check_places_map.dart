import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish/models/User.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:dish/models/PostModel.dart';
import 'package:intl/intl.dart';

class CheckPlacesMap extends StatefulWidget {
  CheckPlacesMap({
    Key? key,
    required this.latLng,
    required this.uid,
    required this.fromPost,
  });
  // のちにお店に修正
  final LatLng latLng;
  final String uid;
  final bool fromPost;

  @override
  State<CheckPlacesMap> createState() => CheckPlacesMapState();
}

class CheckPlacesMapState extends State<CheckPlacesMap> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];
  // todo: initStateで変更した場所にカメラをフォーカス
  CameraPosition? currentPosition;

  Stream<List<PostModel>>? timeline;

  @override
  initState() {
    super.initState();
    setState(
      () {
        currentPosition = CameraPosition(
          target: widget.latLng,
          zoom: 15,
        );
      },
    );
    timeline = FirebaseFirestore.instance
        .collection("USERS")
        .doc(widget.uid)
        .collection("/TIMELINE")
        .orderBy("timestamp", descending: true)
        .limit(20)
        .snapshots()
        .asyncMap(
          (snapshot) => Future.wait(
            [for (var doc in snapshot.docs) _generatePostMap(doc)],
          ),
        );
    print(timeline);
  }

  List<Marker> _generateMaker(List<PostModel> post) {
    List<Marker> markers = [];

    print("post:");
    print(post);

    if (widget.fromPost) {
      markers.add(
        Marker(
          markerId: MarkerId(markers.length.toString()),
          position: widget.latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
      );
    }
    for (int i = 0; i < post.length; i++) {
      if (widget.latLng == post[i].map) continue;
      markers.add(
        Marker(
          markerId: MarkerId((markers.length + i + 1).toString()),
          position: post[i].map,
        ),
      );
    }
    return markers;
  }

  Future<PostModel> _generatePostMap(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    Map<String, dynamic> data = doc.data();
    User user = await _getUser(data["uid"]);
    PostModel postInfo = PostModel(
      id: "item.id",
      content: data["content"],
      restName: data["restaurant_name"],
      // タグの扱いは後ほど考え直す必要あり
      imageUrls: data["image_paths"].cast<String>() as List<String>,
      postUser: user,
      date: DateFormat("yyyy/MM/dd").format(data["timestamp"].toDate()),
      favoUsers: [],
      comments: [],
      map: LatLng(
        data["location"]["lat"] + 0.0,
        data["location"]["lng"] + 0.0,
      ),
      stars: {
        "cost": data["evaluation"]["cost"] + 0.0,
        "mood": data["evaluation"]["mood"] + 0.0,
        "taste": data["evaluation"]["taste"] + 0.0,
      },
    );
    return postInfo;
  }

  Future<User> _getUser(String uid) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection("USERS").doc(uid);
    DocumentSnapshot snapshot = await userRef.get();

    if (!snapshot.exists) {
      print("💣 Something went wrong");
    }

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    User user = User(
      userId: data["user_id"],
      userName: data["user_name"],
      profileText: data["profile_text"],
      iconImageUrl: data["icon_path"],
    );
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: timeline,
            builder: (BuildContext context,
                AsyncSnapshot<List<PostModel>> snapshot) {
              if (snapshot.data == null) {
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: currentPosition!,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                );
              } else {
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: currentPosition!,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _generateMaker(snapshot.data!).toSet(),
                  myLocationEnabled: true,
                );
              }
            },
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
