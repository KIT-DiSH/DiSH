import 'package:flutter/material.dart';

import 'package:dish/models/User.dart';
import 'package:dish/models/Post.dart';
import 'package:dish/widgets/post_screen/post_card.dart';

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
    final user = widget.user;
    final posts = widget.posts;

    return Container(
      child: Column(
        children: [
          Container(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8,
              children: posts.map((post) {
                return PostCard(user: user, post: post);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
