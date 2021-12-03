import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dish/models/User.dart';
import 'package:dish/models/Comment.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/simple_divider.dart';
import 'package:dish/widgets/comment_screen/comment_card.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    Key? key,
    required this.myUid,
    required this.postId,
  }) : super(key: key);

  final String myUid;
  final String postId;

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _title = "コメント";
  final _postButtonText = "投稿する";
  final _hintText = "コメントを追加";
  final _commentController = TextEditingController();
  bool _isEmptyComment = true;
  Stream<List<CommentCard>>? commentStream;

  @override
  void initState() {
    commentStream = FirebaseFirestore.instance
        .collection("COMMENTS")
        .where("post_id", isEqualTo: widget.postId)
        .orderBy("timestamp", descending: false)
        .snapshots()
        .asyncMap((snapshot) => Future.wait(
            [for (var doc in snapshot.docs) _generateCommentCard(doc)]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<CommentCard>>(
                  stream: commentStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CommentCard>> snapshot) {
                    if (snapshot.data == null) {
                      print("📝 Fetch comment now...");
                      return Center(child: CircularProgressIndicator());
                    }

                    final List<CommentCard> commentCardList = snapshot.data!;
                    if (commentCardList.length < 1) {
                      return Center(
                        child: Text("コメントを書いてみましょう"),
                      );
                    }

                    return ListView.separated(
                      itemCount: commentCardList.length + 1,
                      separatorBuilder: (_, __) => SimpleDivider(height: 1.0),
                      itemBuilder: (context, index) {
                        if (index == commentCardList.length)
                          return SimpleDivider(height: 1.0);

                        return widget.myUid ==
                                commentCardList[index].commentInfo.user.uid
                            ? Dismissible(
                                child: commentCardList[index],
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
                                key: ValueKey<CommentCard>(
                                    commentCardList[index]),
                                onDismissed:
                                    (DismissDirection direction) async {
                                  final String res = await _deleteComment(
                                    commentCardList[index].commentInfo.id,
                                  );

                                  if (res == "success")
                                    print("💮 Successed delete comment");
                                  else
                                    print("🤧 Failed delete comment");
                                },
                                confirmDismiss: _confirmDelete,
                              )
                            : commentCardList[index];
                      },
                    );
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
                        onChanged: (text) {
                          setState(() {
                            _isEmptyComment = text.isEmpty;
                          });
                        },
                        style: TextStyle(fontSize: 14),
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
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: !_isEmptyComment
                              ? AppColor.kPinkColor
                              : AppColor.kPinkColor.withOpacity(0.6),
                          padding: EdgeInsets.all(0),
                        ),
                        onPressed: !_isEmptyComment
                            ? () async {
                                final String res = await _addNewComment(
                                  widget.myUid,
                                  widget.postId,
                                  _commentController.text,
                                );

                                FocusScope.of(context).unfocus();

                                if (res == "fail") {
                                  print("💣 Failed add comment");
                                  return;
                                }

                                print("👼 SUCCESSED ADD COMMENT");
                                _commentController.text = "";
                                setState(() {
                                  _isEmptyComment = true;
                                });
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

  Future<String> _addNewComment(
    String uid,
    String postId,
    String content,
  ) async {
    final String res = await FirebaseFirestore.instance
        .collection("COMMENTS")
        .add({
          "post_id": postId,
          "uid": uid,
          "content": content,
          "timestamp": DateTime.now(),
        })
        .then((_) => "success")
        .catchError((_) => "fail");
    return res;
  }

  Future<String> _deleteComment(String commentId) async {
    final String res = await FirebaseFirestore.instance
        .collection("COMMENTS")
        .doc(commentId)
        .delete()
        .then((_) => "success")
        .catchError((_) => "fail");
    return res;
  }

  Future<CommentCard> _generateCommentCard(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    final data = doc.data();
    final User user = await _getUser(data["uid"]);
    final Comment commentInfo = Comment(
      id: doc.id,
      user: user,
      content: data["content"],
      timestamp: DateFormat("yyyy/MM/dd").format(data["timestamp"].toDate()),
    );
    return CommentCard(commentInfo: commentInfo);
  }

  Future<User> _getUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("USERS").doc(uid).get();
    final data = snapshot.data() as Map<String, dynamic>;
    User user = User(
      uid: uid,
      iconImageUrl: data["icon_path"],
      userId: data["user_id"],
      userName: data["user_name"],
      profileText: data["profile_text"],
    );
    return user;
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 1.0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        _title,
        style: TextStyle(
          color: AppColor.kPrimaryTextColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
