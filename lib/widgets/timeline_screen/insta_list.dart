import 'package:flutter/material.dart';

import 'package:dish/widgets/timeline_screen/post.dart';
import 'package:dish/models/PostModel.dart';

class InstaList extends StatefulWidget {
  @override
  _InstaListState createState() => _InstaListState();
}

class _InstaListState extends State<InstaList> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) => DishPost(
        postInfo: posts[index],
      ),
    );
  }
}
