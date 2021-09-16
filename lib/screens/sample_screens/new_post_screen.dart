import 'package:flutter/material.dart';

class NewPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sample screen"),
      ),
      body: Center(
        child: Text("Add New Post"),
      ),
    );
  }
}
