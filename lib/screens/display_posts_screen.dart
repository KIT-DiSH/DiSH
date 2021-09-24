import 'package:flutter/material.dart';

import 'package:dish/models/PostModel.dart';
import 'package:dish/widgets/timeline_screen/post.dart';

class DisplayPostsScreen extends StatefulWidget {
  const DisplayPostsScreen({Key? key}) : super(key: key);

  @override
  _DisplayPostsScreenState createState() => _DisplayPostsScreenState();
}

class _DisplayPostsScreenState extends State<DisplayPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) => DishPost(
            postInfo: posts[index],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("TestUserNameの投稿"),
      centerTitle: true,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
