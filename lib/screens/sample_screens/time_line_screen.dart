import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class TimeLineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sample screen"),
        backgroundColor: AppColor.kWhiteColor,
      ),
      body: SafeArea(
        child: Center(
          child: Text("Time Line"),
        ),
      ),
    );
  }
}
