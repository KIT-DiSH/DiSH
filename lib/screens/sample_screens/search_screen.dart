import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "sample screen",
          style: TextStyle(color: AppColor.kPrimaryTextColor),
        ),
        backgroundColor: AppColor.kWhiteColor,
      ),
      body: SafeArea(
        child: Center(
          child: Text("Search"),
        ),
      ),
    );
  }
}
