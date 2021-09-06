import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/comment_screen/comment_card.dart';

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _title = "コメント";
  final _postButtonText = "投稿する";
  final _hintText = "コメントを追加";
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    CommentCard(),
                    CommentCard(),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColor.kDefaultBorderColor.withOpacity(0.75),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        maxLength: 100,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0),
                          hintText: _hintText,
                          hintStyle: TextStyle(
                            color: AppColor.kPrimaryTextColor.withOpacity(0.6),
                          ),
                          counterText: "",
                        ),
                        style: TextStyle(fontSize: 12),
                        onChanged: (String value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      height: 35,
                      width: 70,
                      child: TextButton(
                        child: Text(
                          _postButtonText,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: AppColor.kPinkColor,
                          padding: EdgeInsets.all(0),
                        ),
                        onPressed: () {
                          // コメント投稿処理を記述
                          _commentController.text = "";
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      ),
    );
  }
}
