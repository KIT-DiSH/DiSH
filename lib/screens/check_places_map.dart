import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish/models/User.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:dish/models/PostModel.dart';
import 'package:dish/widgets/check_places_map/display_image.dart';
import 'package:dish/models/PinModel.dart';

class CheckPlacesMap extends StatefulWidget {
  CheckPlacesMap({
    Key? key,
    required this.latLng,
    required this.uid,
    this.postInfo,
  });
  // のちにお店に修正
  final LatLng latLng;
  final String uid;
  PostModel? postInfo;

  @override
  State<CheckPlacesMap> createState() => CheckPlacesMapState();
}

class CheckPlacesMapState extends State<CheckPlacesMap> {
  Completer<GoogleMapController> _controller = Completer();
  int redIndex = -2;
  CameraPosition? currentPosition;
  String? imagePath;
  String? resName;
  String? postId;
  User? postUser;

  Stream<List<PinModel>>? timeline;

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
    // 初期Window表示
    if (widget.postInfo != null) {
      setState(() {
        imagePath = widget.postInfo!.imageUrls[0];
        resName = widget.postInfo!.restName;
        postId = widget.postInfo!.id;
        postUser = widget.postInfo!.postUser;
      });
    }
    timeline = FirebaseFirestore.instance
        .collection("USERS")
        .doc(widget.uid)
        .collection("/TIMELINE")
        .orderBy("timestamp", descending: true)
        .limit(20)
        .snapshots()
        .asyncMap(
          (snapshot) => Future.wait(
            [for (var doc in snapshot.docs) _generatePinModel(doc)],
          ),
        );
  }

  List<Marker> _generateMarker(List<PinModel> posts) {
    List<Marker> markers = [];

    for (PinModel post in posts) {
      final index = posts.indexWhere((post2) => post2.id == post.id);
      bool initRedPin = false;

      // 投稿からマップに飛んだ時に、その投稿のピンを初期で赤ピンにする
      // ほんとは[redIndex = index]としたいがここでsetStateがが使えないためこんな感じです。
      if (widget.latLng == post.map && widget.postInfo != null) {
        initRedPin = true;
      }
      bool isInitRedPin = initRedPin && redIndex == -2;
      bool isSelected = (redIndex == index) || isInitRedPin;
      markers.add(
        Marker(
          alpha: isSelected ? 1 : 0.95,
          markerId: MarkerId(post.id),
          position: post.map,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected ? BitmapDescriptor.hueRed : 20.0,
          ),
          onTap: () {
            setState(() {
              imagePath = post.imageUrls[0];
              resName = post.restName;
              redIndex = index;
            });
          },
        ),
      );
    }
    return markers;
  }

  Future<PinModel> _generatePinModel(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    Map<String, dynamic> data = doc.data();
    final DocumentReference postRef = data["post_ref"];
    final Map<String, dynamic> postRawData = await postRef
        .get()
        .then((snapshot) => snapshot.data() as Map<String, dynamic>);
    PinModel postInfo = PinModel(
      id: postRef.id,
      restName: postRawData["restaurant_name"],
      imageUrls: postRawData["image_paths"].cast<String>() as List<String>,
      map: LatLng(
        postRawData["location"]["lat"] + 0.0,
        postRawData["location"]["lng"] + 0.0,
      ),
    );
    return postInfo;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: timeline,
            builder:
                (BuildContext context, AsyncSnapshot<List<PinModel>> snapshot) {
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
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (_) {
                    setState(() {
                      redIndex = -1;
                      imagePath = null;
                      resName = null;
                    });
                  },
                  markers: _generateMarker(snapshot.data!).toSet(),
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
          postUser != null
              ? DisplayImage(
                  imagePath: imagePath!,
                  resName: resName!,
                  postId: postId!,
                  postUser: postUser!,
                )
              : Container(),
        ],
      ),
    );
  }
}
