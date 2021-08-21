import 'package:flutter/material.dart';

import 'package:dish/models/User.dart';
import 'package:dish/models/Post.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/profile_screen/posts_field.dart';
import 'package:dish/widgets/profile_screen/profile_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: ListView(
          children: [
            SizedBox(height: 24),
            ProfileField(user: testUser),
            SizedBox(height: 24),
            Divider(
              thickness: 1,
              color: AppColor.kDefaultBorderColor.withOpacity(0.75),
            ),
            SizedBox(height: 4),
            PostsField(user: testUser, posts: testPosts),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(color: Colors.black12),
        child: Center(child: Text("FOOTER")),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        title: Text(
          testUser.userId,
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
          SizedBox(width: 12),
        ],
      ),
    );
  }
}
