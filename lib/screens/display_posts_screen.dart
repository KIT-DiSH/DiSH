import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:dish/models/User.dart';
import 'package:dish/models/PostModel.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/timeline_screen/post.dart';

class DisplayPostsScreen extends StatefulWidget {
  const DisplayPostsScreen({
    Key? key,
    required this.user,
    required this.postId,
  }) : super(key: key);

  final User user;
  final String postId;

  @override
  _DisplayPostsScreenState createState() => _DisplayPostsScreenState();
}

class _DisplayPostsScreenState extends State<DisplayPostsScreen> {
  PostModel? _postInfo;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _getPostInfo(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _postInfo != null
          ? SafeArea(
              child: DishPost(
                postInfo: _postInfo!,
                uid: widget.user.uid!,
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _getPostInfo(String postId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("POSTS").doc(postId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    print(data.toString());
    final postInfo = PostModel(
      id: postId,
      content: data["content"],
      restName: data["restaurant_name"],
      imageUrls: data["image_paths"].cast<String>() as List<String>,
      postUser: widget.user,
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
    setState(() {
      _postInfo = postInfo;
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 1.0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "${widget.user.userId}の投稿",
        style: TextStyle(
          color: AppColor.kPrimaryTextColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
