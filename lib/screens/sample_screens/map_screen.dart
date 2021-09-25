import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sample screen"),
      ),
      body: SafeArea(
        child: Center(
          child: Text("Search With Map"),
        ),
      ),
    );
  }
}
