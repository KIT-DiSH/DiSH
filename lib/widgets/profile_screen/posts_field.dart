import 'package:flutter/material.dart';

import 'package:dish/models/User.dart';
import 'package:dish/models/Post.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/profile_screen/post_card.dart';

class PostsField extends StatefulWidget {
  PostsField({
    Key key,
    @required this.user,
    @required this.posts,
  });

  final List<Post> posts;
  final User user;

  @override
  _PostsFieldState createState() => _PostsFieldState();
}

class _PostsFieldState extends State<PostsField> {
  @override
  Widget build(BuildContext context) {
    final _noPostMessage = "投稿がありません";
    final user = widget.user;
    final posts = widget.posts;

    return posts.length != 0
        ? Container(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8,
              children: posts.map((post) {
                return PostCard(user: user, post: post);
              }).toList(),
            ),
          )
        : Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 120),
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
