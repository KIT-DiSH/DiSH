import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/simple_divider.dart';
import 'package:dish/widgets/follow_follower_list_screen/user_card.dart';

class FollowerListScreen extends StatefulWidget {
  const FollowerListScreen({Key? key}) : super(key: key);

  @override
  _FollowerListScreenState createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
  final _title = "フォロワー";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              UserCard(),
              SimpleDivider(height: 1.0),
            ],
          ),
        ),
      ),
    );
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
