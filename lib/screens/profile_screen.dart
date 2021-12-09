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
  const ProfileScreen({
    Key? key,
    required this.uid,
    required this.openFooter,
    required this.closeFooter,
    this.popUntilFirstScreen,
  }) : super(key: key);

  final String uid;
  final VoidCallback openFooter;
  final VoidCallback closeFooter;
  final VoidCallback? popUntilFirstScreen;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _myself;
  String _userId = "";
  int _postsCount = 0;
  int _followCount = 0;
  int _followerCount = 0;
  Stream<User>? userStream;
  Stream<List<Post>>? postsStream;
  final String myUid = firebaseAuth.FirebaseAuth.instance.currentUser!.uid;

  Future<User> _generateUserProfile(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final data = snapshot.data() as Map<String, dynamic>;
    final postsCount = await _getPostsCount(widget.uid);
    final followCount = await _getFollowCount(widget.uid, "follow");
    final followerCount = await _getFollowCount(widget.uid, "follower");
    setState(() {
      _postsCount = postsCount;
      _followCount = followCount;
      _followerCount = followerCount;
    });
    User user = User(
      uid: widget.uid,
      profileText: data["profile_text"],
      userId: data["user_id"],
      userName: data["user_name"],
      iconImageUrl: data["icon_path"],
      postCount: _postsCount,
      followCount: _followCount,
      followerCount: _followerCount,
    );
    setState(() {
      _myself = user;
      _userId = data["user_id"];
    });
    return user;
  }

  Future<Post> _generatePost(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    final int postsCount = await _getPostsCount(widget.uid);
    setState(() {
      if (_myself != null) _myself!.postCount = postsCount;
    });
    Map<String, dynamic> data = doc.data();
    Post post = Post(
      userId: _userId,
      postId: doc.id,
      postText: data["content"],
      postImageUrls: data["image_paths"].cast<String>() as List<String>,
      postedDate: DateFormat("yyyy/MM/dd").format(data["timestamp"].toDate()),
      commentCount: 0,
      favoCount: 0,
      stars: {
        "cost": data["evaluation"]["cost"] + 0.0,
        "mood": data["evaluation"]["mood"] + 0.0,
        "taste": data["evaluation"]["taste"] + 0.0,
      },
    );
    return post;
  }

  @override
  void initState() {
    userStream = FirebaseFirestore.instance
        .collection("USERS")
        .doc(widget.uid)
        .snapshots()
        .asyncMap((snapshot) => _generateUserProfile(snapshot));
    postsStream = FirebaseFirestore.instance
        .collection("POSTS")
        .where("uid", isEqualTo: widget.uid)
        .snapshots()
        .asyncMap((snapshot) =>
            Future.wait([for (var doc in snapshot.docs) _generatePost(doc)]));
    super.initState();
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
              StreamBuilder(
                stream: userStream,
                builder: (BuildContext context, AsyncSnapshot<User> user) {
                  if (user.data == null) {
                    print("⌚ Fetch data now...");
                    return Center(child: CircularProgressIndicator());
                  }
                  return ProfileField(
                    uid: widget.uid,
                    myUid: myUid,
                    user: user.data!,
                    openFooter: widget.openFooter,
                    closeFooter: widget.closeFooter,
                  );
                },
              ),
              const SizedBox(height: 24),
              SimpleDivider(),
              const SizedBox(height: 4),
              StreamBuilder(
                stream: postsStream,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Post>> posts) {
                  if (posts.data == null || _myself == null) {
                    print("⌚ Fetch data now...");
                    return Center(child: CircularProgressIndicator());
                  }
                  return PostsField(
                    user: _myself!,
                    posts: posts.data!,
                    openFooter: widget.openFooter,
                    closeFooter: widget.closeFooter,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _getPostsCount(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("POSTS")
        .where("uid", isEqualTo: uid)
        .get();
    return snapshot.docs.length;
  }

  Future<int> _getFollowCount(String uid, String type) async {
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
    if (type == "follow")
      return snapshot.docs.length;
    else
      return snapshot.docs.length;
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
        widget.uid == myUid
            ? GestureDetector(
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
                                  widget.popUntilFirstScreen!();
                                } else {
                                  print("💀 FAIL LOGOUT");
                                  print(res);
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
              )
            : Container(),
        const SizedBox(width: 12),
      ],
    );
  }
}
