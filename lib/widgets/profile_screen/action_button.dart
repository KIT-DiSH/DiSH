import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish/models/User.dart';
import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/screens/edit_profile_screen.dart';

class ActionButton extends StatefulWidget {
  ActionButton({
    Key? key,
    required this.uid,
    required this.myUid,
    required this.user,
    required this.userType,
    required this.setUserType,
  });

  final User user;
  final String uid;
  final String myUid;
  final String? userType;
  final void Function(String) setUserType;

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  final _myselfLabel = "プロフィールを編集する";
  final _followedLabel = "フォロー解除する";
  final _strangerLabel = "フォローする";
  final _defaultLabel = "読み込み中";

  @override
  Widget build(BuildContext context) {
    final _setUserType = widget.setUserType;
    String? _userType = widget.userType;

    switch (_userType) {
      case "myself":
        return Container(
          height: 36,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColor.kDefaultBorderColor),
          ),
          child: TextButton(
            child: Text(
              _myselfLabel,
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
            style: TextButton.styleFrom(
              primary: AppColor.kPrimaryTextColor,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            onPressed: () {
              // プロフィール編集画面へ遷移
              print("Navigate to EditProfileScreen");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return EditProfileScreen(uid: widget.uid, user: widget.user);
                }),
              );
            },
          ),
        );
      case "followed":
        {
          return Container(
            height: 36,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: AppColor.kDefaultBorderColor),
            ),
            child: TextButton(
              child: Text(
                _followedLabel,
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              style: TextButton.styleFrom(
                primary: AppColor.kPrimaryTextColor,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              onPressed: () {
                _setUserType("stranger");
                _unfollowUser(widget.uid, widget.myUid);
                print("unfollowed");
                setState(() {
                  // フォロー解除処理
                });
              },
            ),
          );
        }
      case "stranger":
        {
          return Container(
            height: 36,
            width: double.infinity,
            child: TextButton(
              child: Text(
                _strangerLabel,
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: AppColor.kPinkColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              onPressed: () async {
                _setUserType("followed");
                print("followed");
                _followUser(widget.uid, widget.myUid);

                setState(() {
                  // フォロー処理
                });
              },
            ),
          );
        }
      default:
        return Container(
          height: 36,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColor.kDefaultBorderColor),
          ),
          child: TextButton(
            child: Text(
              _defaultLabel,
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
            style: TextButton.styleFrom(
              primary: AppColor.kPrimaryTextColor,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            onPressed: null,
          ),
        );
    }
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
}
