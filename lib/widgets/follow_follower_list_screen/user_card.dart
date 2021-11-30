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
  }) : super(key: key);

  final User user;
  bool didFollow;
  final String myselfUid;

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
        .onError((error, stackTrace) => "fail");
    if (res == "fail") return "fail";
  }
  return 'success';
}

class _UserCardState extends State<UserCard> {
  final _followedLabel = "フォロー中";
  final _notFollowedLabel = "フォロー";

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
                    builder: (_) => ProfileScreen(uid: widget.user.uid!)),
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
          widget.didFollow
              ? Container(
                  width: 88,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: AppColor.kDefaultBorderColor),
                  ),
                  child: TextButton(
                    child: Text(
                      _followedLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.kPrimaryTextColor.withOpacity(0.7),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black12,
                      backgroundColor: Color(0xFFF5F5F5),
                    ),
                    onPressed: () {
                      setState(() {
                        // フォロー解除処理
                        widget.didFollow = false;
                      });
                      _unfollowUser(widget.user.uid!, widget.myselfUid);
                    },
                  ),
                )
              : Container(
                  width: 88,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextButton(
                    child: Text(
                      _notFollowedLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black12,
                      backgroundColor: AppColor.kPinkColor,
                    ),
                    onPressed: () {
                      setState(() {
                        // フォロー処理
                        widget.didFollow = true;
                      });
                      _followUser(widget.user.uid!, widget.myselfUid);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
