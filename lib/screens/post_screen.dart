import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleText = "新規投稿";
    final _hintText = "投稿文を書く";
    final _restaurantName = "";

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        title: Text(_titleText),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: AppColor.kPinkColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      child: Text(
                        _restaurantName != "" ? _restaurantName : "店名",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      child: TextField(
                        style: TextStyle(
                          fontSize: 12.0,
                          color: AppColor.kPrimaryTextColor,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: _hintText,
                        ),
                      ),
                      height: 250,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
