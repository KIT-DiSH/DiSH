import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:dish/models/User.dart';
import 'package:dish/models/PostModel.dart';
import 'package:dish/widgets/timeline_screen/post.dart';

class DiSHList extends StatefulWidget {
  const DiSHList({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  _DiSHListState createState() => _DiSHListState();
}

class _DiSHListState extends State<DiSHList> {
  Stream<List<DishPost>>? timelineStream;

  @override
  void initState() {
    // 最新のタイムラインを20件取得する
    // 自動更新あり
    timelineStream = FirebaseFirestore.instance
        .collection("USERS")
        .doc(widget.uid)
        .collection("/TIMELINE")
        .orderBy("timestamp", descending: true)
        .limit(20)
        .snapshots()
        .asyncMap((snapshot) => Future.wait(
            [for (var doc in snapshot.docs) _generateDiSHPost(doc)]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: StreamBuilder(
            stream: timelineStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<DishPost>> posts) {
              if (posts.data == null) {
                print("⌚ Fetch data now...");
                return Center(child: CircularProgressIndicator());
              } else if (posts.data!.length < 1) {
                print("Nothing posts");
                return Center(
                  child: Text("知り合いをフォローしてみましょう！"),
                );
              }
              return ListView(children: posts.data!);
            },
          ),
        ),
      ],
    );
  }

  Future<DishPost> _generateDiSHPost(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    final Map<String, dynamic> data = doc.data();
    final DocumentReference postRef = data["post_ref"];
    final Map<String, dynamic> postRawData = await postRef
        .get()
        .then((snapshot) => snapshot.data() as Map<String, dynamic>);

    User user = await _getUser(postRawData["uid"]);

    PostModel postInfo = PostModel(
      id: postRef.id,
      content: postRawData["content"],
      restName: postRawData["restaurant_name"],
      imageUrls: postRawData["image_paths"].cast<String>() as List<String>,
      postUser: user,
      date: DateFormat("yyyy/MM/dd").format(postRawData["timestamp"].toDate()),
      favoUsers: [],
      comments: [],
      map: LatLng(
        postRawData["location"]["lat"] + 0.0,
        postRawData["location"]["lng"] + 0.0,
      ),
      stars: {
        "cost": postRawData["evaluation"]["cost"] + 0.0,
        "mood": postRawData["evaluation"]["mood"] + 0.0,
        "taste": postRawData["evaluation"]["taste"] + 0.0,
      },
    );
    return DishPost(uid: postRawData["uid"], postInfo: postInfo);
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
}
