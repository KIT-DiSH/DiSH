import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class SettingScreen extends StatelessWidget {
  final _title = "設定";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        child: ListView(
          children: [],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(color: Colors.black12),
        child: Center(child: Text("footer")),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        title: Text(
          _title,
          style: TextStyle(
            color: AppColor.kPrimaryTextColor,
            fontSize: 16,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.more_horiz,
              color: AppColor.kPrimaryTextColor,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }
}
