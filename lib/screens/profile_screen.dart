import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

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
  User? _myself;
  String _userId = "";
  List<Post> _posts = [];
  int _postsCount = 0;
  int _followCount = 0;
  int _followerCount = 0;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _getPostsCount(widget.uid);
    await _getFollowCount(widget.uid, "follow");
    await _getFollowCount(widget.uid, "follower");
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
                  ? ProfileField(uid: widget.uid, user: _myself!)
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
      followCount: _followCount,
      followerCount: _followerCount,
      postCount: _postsCount,
    );
    setState(() {
      _myself = myself;
      _userId = data["user_id"];
    });
  }

  Future<void> _getUserPosts(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("POSTS")
        .where("uid", isEqualTo: uid)
        .get();

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

  Future<void> _getPostsCount(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("POSTS")
        .where("uid", isEqualTo: uid)
        .get();
    setState(() {
      _postsCount = snapshot.docs.length;
    });
  }

  Future<void> _getFollowCount(String uid, String type) async {
    String? searchKey;
    if (type == "follow")
      searchKey = "followee_id";
    else
      searchKey = "follower_id";
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("FOLLOW_FOLLOWER")
        .where(searchKey, isEqualTo: uid)
        .get();
    setState(() {
      if (type == "follow")
        _followCount = snapshot.docs.length;
      else
        _followerCount = snapshot.docs.length;
    });
  }

  Future<String> signOut() async {
    try {
      await firebaseAuth.FirebaseAuth.instance.signOut();
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
          onTap: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              builder: (BuildContext context) {
                return SizedBox(
                  height: 210,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("ログアウト"),
                        onTap: () async {
                          final String res = await signOut();
                          if (res == "success") {
                            print("💮 SUCCESS LOGOUT");
                            // ここでログイン画面に遷移する
                          } else {
                            print("💀 FAIL LOGOUT");
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Icon(
            Icons.more_horiz,
            color: AppColor.kPrimaryTextColor,
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
