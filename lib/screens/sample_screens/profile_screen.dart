import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sample screen"),
      ),
      body: Center(
        child: Text("User Profile"),
      ),
    );
  }
}
