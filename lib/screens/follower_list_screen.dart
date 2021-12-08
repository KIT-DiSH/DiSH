import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dish/models/User.dart' as Dish;
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/simple_divider.dart';
import 'package:dish/widgets/follow_follower_list_screen/user_card.dart';

class FollowerListScreen extends StatefulWidget {
  const FollowerListScreen({
    Key? key,
    required this.uid,
    required this.openFooter,
    required this.closeFooter,
  }) : super(key: key);

  final String uid;
  final VoidCallback openFooter;
  final VoidCallback closeFooter;

  @override
  _FollowerListScreenState createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
  final _title = "フォロワー";
  List<String> _followerIdList = [];
  List<Map> _userList = [];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _getFollowerIdList(widget.uid);
    await _setUserList(_followerIdList);
  }

  @override
  Widget build(BuildContext context) {
    final deviceUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: ListView.separated(
          itemBuilder: (context, index) {
            if (index == _userList.length) return SimpleDivider(height: 1.0);

            return UserCard(
              user: _userList[index]["user"],
              didFollow: _userList[index]["didFollow"],
              myselfUid: widget.uid,
              openFooter: widget.openFooter,
              closeFooter: widget.closeFooter,
              deviceUid: deviceUid,
            );
          },
          separatorBuilder: (_, __) => SimpleDivider(height: 1.0),
          itemCount: _userList.length + 1,
        ),
      ),
    );
  }

  Future<Map> _getUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("USERS").doc(uid).get();
    final data = snapshot.data() as Map<String, dynamic>;
    Dish.User user = Dish.User(
      uid: uid,
      iconImageUrl: data["icon_path"],
      userId: data["user_id"],
      userName: data["user_name"],
      profileText: data["profile_text"],
    );

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("FOLLOW_FOLLOWER")
        .where("follower_id", isEqualTo: uid)
        .where("followee_id", isEqualTo: widget.uid)
        .get();
    final didFollow = querySnapshot.docs.length > 0;
    return {"didFollow": didFollow, "user": user};
  }

  Future<void> _setUserList(List<String> idList) async {
    List<Map> userList =
        await Future.wait(idList.map((String id) => _getUser(id)));
    setState(() {
      _userList = userList;
    });
  }

  Future<void> _getFollowerIdList(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("FOLLOW_FOLLOWER")
        .where("follower_id", isEqualTo: widget.uid)
        .get();
    final List<String> followerIdList = snapshot.docs.map((doc) {
      final data = doc.data();
      return data["followee_id"] as String;
    }).toList();
    setState(() {
      _followerIdList = followerIdList;
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
        _title,
        style: TextStyle(
          color: AppColor.kPrimaryTextColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
