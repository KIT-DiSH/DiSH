import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:dish/models/User.dart';
import 'package:dish/models/Post.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/screens/display_posts_screen.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
    required this.user,
    required this.post,
    required this.openFooter,
    required this.closeFooter,
  }) : super(key: key);

  final User user;
  final Post post;
  final VoidCallback openFooter;
  final VoidCallback closeFooter;

  @override
  Widget build(BuildContext context) {
    final _cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    final _cardHeight = 340.0;
    final _favoLabel = "favorite";
    final _commentLabel = "comment";

    return GestureDetector(
      onTap: () {
        print("Navigate to DisplayPostsScreen");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return DisplayPostsScreen(
              user: user,
              postId: post.postId,
              openFooter: openFooter,
              closeFooter: closeFooter,
            );
          }),
        );
      },
      child: SizedBox(
        height: _cardHeight,
        width: _cardWidth,
        child: Column(
          children: [
            // 投稿画像
            SizedBox(
              height: _cardWidth,
              width: _cardWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  post.postImageUrls[0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // アイコン、ユーザー名、星
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Container(
                    height: 28,
                    width: 28,
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
                        user.iconImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.userId,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildEvalStars(),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 投稿テキスト
            Container(
              width: _cardWidth,
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text(
                post.postText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.kPrimaryTextColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // いいね数、コメント数、投稿日時
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconWithCounter(_favoLabel, post.favoCount),
                  const SizedBox(width: 8),
                  _buildIconWithCounter(_commentLabel, post.commentCount),
                  const Spacer(),
                  Text(
                    post.postedDate,
                    style: TextStyle(
                      color: AppColor.kPrimaryTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildIconWithCounter(String label, int num) {
    final _iconMap = {
      "favorite": Icons.favorite,
      "comment": Icons.comment,
    };

    return Row(
      children: [
        Icon(
          _iconMap[label],
          size: 16,
          color: Colors.black12,
        ),
        const SizedBox(width: 2),
        Text(
          NumberFormat.compact().format(num),
          style: TextStyle(
            color: AppColor.kPrimaryTextColor,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // 星の表示切替方法は後々検討する
  Row _buildEvalStars() {
    Icon _getStar(bool isFill) {
      return Icon(
        Icons.star,
        size: 12,
        color: AppColor.kStarYellowColor,
      );
    }

    return Row(
      children: [
        _getStar(true),
        _getStar(true),
        _getStar(true),
        _getStar(true),
        _getStar(true),
      ],
    );
  }
}
