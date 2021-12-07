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
    required this.uid,
    required this.latLng,
    required this.openFooter,
    required this.closeFooter,
    this.postInfo,
  });
  // のちにお店に修正
  final String uid;
  final LatLng latLng;
  final VoidCallback openFooter;
  final VoidCallback closeFooter;
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
  List<Marker> _markers = [];

  Future<QuerySnapshot<Map<String, dynamic>>>? timeline;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final tmp = await _generateMarker();
    setState(() {
      _markers = tmp;
    });
  }

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
    // timeline = FirebaseFirestore.instance
    //     .collection("USERS")
    //     .doc(widget.uid)
    //     .collection("/TIMELINE")
    //     .orderBy("timestamp", descending: true)
    //     .limit(20)
    //     .get();
    // .snapshots()
    // .asyncMap(
    //   (snapshot) => Future.wait(
    //     [for (var doc in snapshot.docs) _generatePinModel(doc)],
    //   ),
    // );
  }

  Future<List<Marker>> _generateMarker() async {
    List<Marker> markers = [];

    final posts = await _generatePinModels();

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
              postId = post.id;
              postUser = post.user;
              redIndex = index;
            });
            print(isSelected);
          },
        ),
      );
    }
    return markers;
  }

  Future<List<PinModel>> _generatePinModels() async {
    final timeline = await FirebaseFirestore.instance
        .collection("USERS")
        .doc(widget.uid)
        .collection("/TIMELINE")
        .orderBy("timestamp", descending: true)
        .limit(20)
        .get();
    final docs = timeline.docs;
    List<PinModel> postInfos = [];
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data();
      final DocumentReference postRef = data["post_ref"];
      final Map<String, dynamic> postRawData = await postRef
          .get()
          .then((snapshot) => snapshot.data() as Map<String, dynamic>);

      final user = await _getUser(postRawData["uid"]);

      PinModel postInfo = PinModel(
        id: postRef.id,
        restName: postRawData["restaurant_name"],
        imageUrls: postRawData["image_paths"].cast<String>() as List<String>,
        map: LatLng(
          postRawData["location"]["lat"] + 0.0,
          postRawData["location"]["lng"] + 0.0,
        ),
        user: user,
      );
      postInfos.add(postInfo);
    }
    return postInfos;
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
      uid: uid,
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
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: currentPosition!,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (_) {
              setState(() {
                redIndex = -1;
                postUser = null;
                imagePath = null;
                resName = null;
                postId = null;
              });
            },
            markers: _markers.toSet(),
            myLocationEnabled: true,
          ),
          //   FutureBuilder(
          //     future: _generateMarker(),
          //     builder:
          //         (BuildContext context, AsyncSnapshot<List<Marker>> snapshot) {
          //       if (snapshot.data == null) {
          //         return GoogleMap(
          //           mapType: MapType.normal,
          //           initialCameraPosition: currentPosition!,
          //           onMapCreated: (GoogleMapController controller) {
          //             _controller.complete(controller);
          //           },
          //           myLocationEnabled: true,
          //         );
          //       } else {
          //         // final timeline = snapshot.data;
          //         // final docs = timeline!.docs;
          //         // final data = docs[0].data();
          //         // print(data);
          //         final markers = snapshot.data!;
          //         return GoogleMap(
          //           mapType: MapType.normal,
          //           initialCameraPosition: currentPosition!,
          //           myLocationButtonEnabled: false,
          //           onMapCreated: (GoogleMapController controller) {
          //             _controller.complete(controller);
          //           },
          //           onTap: (_) {
          //             setState(() {
          //               redIndex = -1;
          //               postUser = null;
          //               imagePath = null;
          //               resName = null;
          //               postId = null;
          //             });
          //           },
          //           markers: markers.toSet(),
          //           myLocationEnabled: true,
          //         );
          //       }
          //     },
          //   ),
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
                  widget.openFooter();
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
                  openFooter: widget.openFooter,
                  closeFooter: widget.closeFooter,
                )
              : Container(),
        ],
      ),
    );
  }
}
