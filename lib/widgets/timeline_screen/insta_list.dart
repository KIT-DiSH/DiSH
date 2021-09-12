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
      itemBuilder: (context, index) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DishPost(
            imageUrl: posts[index].image,
            userName: posts[index].user.name,
            star: posts[index].star,
            shopName: posts[index].shop,
            description: posts[index].discription,
            tags: posts[index].tags,
          ),
        ],
      ),
    );
  }
}
