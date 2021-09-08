import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/simple_divider.dart';
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
  List _commentCards = [
    CommentCard(),
    CommentCard(),
  ];
  final _isMyComment = true;

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
                child: ListView.builder(
                  itemCount: _commentCards.length,
                  itemBuilder: (BuildContext context, int index) {
                    // 便宜上 _isMyComment という変数を用いている
                    // データ構造に基づいて後々変更する
                    return _isMyComment
                        ? Dismissible(
                            child: _commentCards[index],
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              color: Colors.redAccent,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            key: ValueKey<CommentCard>(_commentCards[index]),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                _commentCards.removeAt(index);
                              });
                            },
                            confirmDismiss: _confirmDelete,
                          )
                        : _commentCards[index];
                  },
                ),
              ),
              SimpleDivider(height: 1.0),
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
                      ),
                    ),
                    const SizedBox(width: 8),
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
                          backgroundColor: _commentController.text != ""
                              ? AppColor.kPinkColor
                              : AppColor.kPinkColor.withOpacity(0.6),
                          padding: EdgeInsets.all(0),
                        ),
                        onPressed: _commentController.text != ""
                            ? () {
                                // コメント投稿処理を記述
                                setState(() {
                                  // 仮のコード
                                  _commentCards.add(CommentCard());
                                });
                                print("Add new comment: " +
                                    _commentController.text);
                                _commentController.text = "";
                                FocusScope.of(context).unfocus();
                              }
                            : null,
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

  Future<bool> _confirmDelete(DismissDirection direction) async {
    const _alertTitle = "確認";
    const _alertContent = "コメントを削除しますか？";
    const _deleteText = "削除";
    const _cancelText = "キャンセル";

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(_alertTitle),
          content: const Text(_alertContent),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(_deleteText)),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(_cancelText),
            ),
          ],
        );
      },
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
