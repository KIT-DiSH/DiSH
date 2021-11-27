import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dish/models/User.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/simple_divider.dart';
import 'package:dish/widgets/follow_follower_list_screen/user_card.dart';

class FollowListScreen extends StatefulWidget {
  const FollowListScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  _FollowListScreenState createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  final _title = "フォロー中";
  List<String> _followIdList = [];
  List<User> _userList = [];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _getFollowIdList(widget.uid);
    await _setUserList(_followIdList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: ListView.separated(
          itemBuilder: (context, index) {
            if (index == _userList.length) return SimpleDivider(height: 1.0);

            return UserCard(
              user: _userList[index],
              isFollowed: true,
            );
          },
          separatorBuilder: (_, __) => SimpleDivider(height: 1.0),
          itemCount: _userList.length + 1,
        ),
      ),
    );
  }

  Future<User> _getUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("USERS").doc(uid).get();
    final data = snapshot.data() as Map<String, dynamic>;
    User user = User(
      uid: uid,
      iconImageUrl: data["icon_path"],
      userId: data["user_id"],
      userName: data["user_name"],
      profileText: data["profile_text"],
    );
    return user;
  }

  Future<void> _setUserList(List<String> idList) async {
    List<User> userList =
        await Future.wait(idList.map((String id) => _getUser(id)));
    setState(() {
      _userList = userList;
    });
  }

  Future<void> _getFollowIdList(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("FOLLOW_FOLLOWER")
        .where("followee_id", isEqualTo: widget.uid)
        .get();
    final List<String> followIdList = snapshot.docs.map((doc) {
      final data = doc.data();
      return data["follower_id"] as String;
    }).toList();
    setState(() {
      _followIdList = followIdList;
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
    );
  }
}
