import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dish/models/User.dart';
import 'package:dish/models/Post.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/simple_divider.dart';
import 'package:dish/widgets/profile_screen/posts_field.dart';
import 'package:dish/widgets/profile_screen/profile_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userId = "";
  User? _myself;
  List<Post> _posts = [];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _getUser(widget.uid);
    await _getUserPosts(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: ListView(
            children: [
              const SizedBox(height: 24),
              _myself != null
                  ? ProfileField(user: _myself!)
                  : Center(child: CircularProgressIndicator()),
              const SizedBox(height: 24),
              SimpleDivider(),
              const SizedBox(height: 4),
              _myself != null
                  ? PostsField(user: _myself!, posts: _posts)
                  : Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getUser(String uid) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection("USERS").doc(uid);
    DocumentSnapshot snapshot = await userRef.get();

    if (!snapshot.exists) {
      print("Something went wrong");
      return;
    }

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    User myself = User(
      userId: data["user_id"],
      userName: data["user_name"],
      profileText: data["profile_text"],
      iconImageUrl: data["icon_path"],
      followCount: 200,
      followerCount: 210,
      postCount: 10,
    );
    setState(() {
      _myself = myself;
      _userId = data["user_id"];
    });
  }

  Future<void> _getUserPosts(String uid) async {
    CollectionReference postsRef = FirebaseFirestore.instance
        .collection("USERS")
        .doc(uid)
        .collection("POSTS");
    QuerySnapshot snapshot = await postsRef.get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;
    if (docs.isNotEmpty) {
      List<Post> posts = docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Post post = Post(
          userId: _userId,
          postId: doc.id,
          postText: data["content"],
          postImageUrls: data["image_paths"].cast<String>() as List<String>,
          postedDate:
              DateFormat("yyyy/MM/dd").format(data["timestamp"].toDate()),
          commentCount: 0,
          favoCount: 0,
        );
        return post;
      }).toList();

      setState(() {
        _posts = posts;
      });
    }
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.kWhiteColor,
        elevation: 1.0,
        // popが存在するときだけ表示する
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: Text(
          _userId,
          style: TextStyle(
            color: AppColor.kPrimaryTextColor,
            fontSize: 16,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.more_horiz,
              color: AppColor.kPrimaryTextColor,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
