import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    print(timeline);
  }

  List<Marker> _generateMaker(List<PinModel> posts) {
    List<Marker> markers = [];

    for (PinModel post in posts) {
      if (widget.latLng == post.map && widget.fromPost) {
        markers.add(
          Marker(
            markerId: MarkerId(markers.length.toString()),
            position: post.map,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            // onTap: () {
            //   print(post.restName);
            // },
          ),
        );
      } else {
        markers.add(
          Marker(
            markerId: MarkerId((markers.length).toString()),
            position: post.map,
            // onTap: () {
            //   print(post.restName);
            // },
          ),
        );
      }
    }
    return markers;
  }

  Future<PinModel> _generatePinModel(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    Map<String, dynamic> data = doc.data();
    PinModel postInfo = PinModel(
      restName: data["restaurant_name"],
      imageUrls: data["image_paths"].cast<String>() as List<String>,
      map: LatLng(
        data["location"]["lat"] + 0.0,
        data["location"]["lng"] + 0.0,
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
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                "https://firebasestorage.googleapis.com/v0/b/dish-dev-af497.appspot.com/o/post_images%2FSf9Yz7ZrQhh1wNr5hiZTv5Vwth13%2FVpziEcZdAr2F?alt=media&token=97ce0c70-a08a-4815-8715-29acb3dcd1a0",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  "叙々苑",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
