import 'package:flutter/material.dart';

import 'package:dish/models/Comment.dart';
import 'package:dish/screens/profile_screen.dart';
import 'package:dish/configs/constant_colors.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    Key? key,
    required this.commentInfo,
  }) : super(key: key);

  final Comment commentInfo;
  final _replyText = "返信する";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // アイコン
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      ProfileScreen(uid: commentInfo.user.uid!),
                ),
              );
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.kPinkColor,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Image.network(
                  commentInfo.user.iconImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commentInfo.user.userId,
                    style: TextStyle(
                      color: AppColor.kPrimaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    commentInfo.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.kPrimaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 返信処理を実装する
                          // コメント入力フォームにメンションを付けるだけにするかも
                          // 返信の必要性が怪しければ除去する可能性もあり
                          print("Tap reply button");
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.reply,
                              size: 18,
                              color: Colors.black26,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _replyText,
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    AppColor.kPrimaryTextColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        commentInfo.timestamp,
                        style: TextStyle(
                          color: AppColor.kPrimaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
