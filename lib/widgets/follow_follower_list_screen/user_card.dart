import 'package:dish/widgets/follow_follower_list_screen/follow_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dish/models/User.dart';
import 'package:dish/screens/profile_screen.dart';
import 'package:dish/configs/constant_colors.dart';

class UserCard extends StatefulWidget {
  UserCard({
    Key? key,
    required this.user,
    required this.didFollow,
    required this.myselfUid,
    required this.openFooter,
    required this.closeFooter,
  }) : super(key: key);

  final User user;
  bool didFollow;
  final String myselfUid;
  final VoidCallback openFooter;
  final VoidCallback closeFooter;

  @override
  _UserCardState createState() => _UserCardState();
}

Future<String> _followUser(String followerUid, String followeeUid) async {
  print("$followeeUid, $followerUid");
  Future<String> res =
      FirebaseFirestore.instance.collection('FOLLOW_FOLLOWER').add({
    "follower_id": followerUid,
    "followee_id": followeeUid,
  }).then((value) {
    return value.id;
  }).catchError((e) => "fail: $e");

  return res;
}

Future<String> _unfollowUser(String followerUid, String followeeUid) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection("FOLLOW_FOLLOWER")
      .where('follower_id', isEqualTo: followerUid)
      .where('followee_id', isEqualTo: followeeUid)
      .get();

  for (QueryDocumentSnapshot doc in snapshot.docs) {
    final String res = await doc.reference
        .delete()
        .then((_) => "success")
        .catchError((_) => "fail");
    if (res == "fail") return "fail";
  }
  return 'success';
}

class _UserCardState extends State<UserCard> {
  void followUser() {
    setState(() {
      // フォロー処理
      widget.didFollow = true;
    });
    _followUser(widget.user.uid!, widget.myselfUid);
  }

  void unFollowUser() {
    setState(() {
      // フォロー解除処理
      widget.didFollow = false;
    });
    _unfollowUser(widget.user.uid!, widget.myselfUid);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 12,
      ),
      decoration: BoxDecoration(color: Color(0xFFFBFBFB)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                          uid: widget.user.uid!,
                          openFooter: widget.openFooter,
                          closeFooter: widget.closeFooter,
                        )),
              );
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.kPinkColor,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Image.network(
                  widget.user.iconImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.userName,
                style: TextStyle(
                  color: AppColor.kPrimaryTextColor,
                  fontSize: 12,
                ),
              ),
              Text(
                widget.user.userId,
                style: TextStyle(
                  color: AppColor.kPrimaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Spacer(),
          FollowButton(
            didFollow: widget.didFollow,
            followUser: followUser,
            unFollowUser: unFollowUser,
          ),
        ],
      ),
    );
  }
}
