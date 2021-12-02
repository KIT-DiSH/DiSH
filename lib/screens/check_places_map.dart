import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish/widgets/check_places_map/display_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:dish/models/PinModel.dart';

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
  String? imagePath;
  String? resName;

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
    // if (widget.fromPost) {
    //   setState(() {
    //     imagePath = post.imageUrls[0];
    //     resName = post.restName;
    //   });
    // }
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
    // List<Marker> markers = [];

    for (PinModel post in posts) {
      if (widget.latLng == post.map && widget.fromPost) {
        markers.add(
          Marker(
            markerId: MarkerId(post.id),
            position: post.map,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            onTap: () {
              setState(() {
                imagePath = post.imageUrls[0];
                resName = post.restName;
              });
            },
          ),
        );
      } else {
        markers.add(
          Marker(
            markerId: MarkerId(post.id),
            position: post.map,
            onTap: () {
              final index = posts.indexWhere((post2) => post2.id == post.id);
              setState(() {
                imagePath = post.imageUrls[0];
                resName = post.restName;
              });
              setState(() {
                markers[index] = markers[index].copyWith(
                    iconParam: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ));
              });
              // print(markers
              //     .where((item) => item.markerId == MarkerId(post.id))
              //     .toList()[0]
              //     .position);

              // print(posts
              //     .where((post2) => post2.id == post.id)
              //     .toList()[0]
              //     .restName);
              // print(posts.indexWhere((post2) => post2.id == post.id));

              // print("aaa");
            },
          ),
        );
      }
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
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
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
          imagePath != null
              ? DisplayImage(
                  imagePath: imagePath!,
                  resName: resName!,
                )
              : Container(),
        ],
      ),
    );
  }
}
