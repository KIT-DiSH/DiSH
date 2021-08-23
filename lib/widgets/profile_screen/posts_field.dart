import 'package:flutter/material.dart';

import 'package:dish/models/User.dart';
import 'package:dish/models/Post.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/profile_screen/post_card.dart';

class PostsField extends StatelessWidget {
  PostsField({
    Key key,
    @required this.user,
    @required this.posts,
  });

  final List<Post> posts;
  final User user;

  @override
  Widget build(BuildContext context) {
    final _noPostMessage = "投稿がありません";

    if (posts.length != 0) {
      return Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 8,
        children: posts.map((post) {
          return PostCard(user: user, post: post);
        }).toList(),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 120),
        child: Text(
          _noPostMessage,
          style: TextStyle(
            fontSize: 16,
            color: AppColor.kPrimaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
