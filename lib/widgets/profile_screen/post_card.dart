import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:dish/models/User.dart';
import 'package:dish/models/Post.dart';
import 'package:dish/configs/constant_colors.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key key,
    @required this.user,
    @required this.post,
  }) : super(key: key);

  final User user;
  final Post post;

  @override
  Widget build(BuildContext context) {
    final _cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    final _cardHeight = 340.0;
    final _favoLabel = "favorite";
    final _commentLabel = "comment";

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: _cardHeight,
        width: _cardWidth,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                post.postImageUrls[0],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Container(
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
                      Container(
                        child: Text(
                          post.userId,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildEvalStars(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
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
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconWithCounter(_favoLabel, post.favoCount),
                  SizedBox(width: 8),
                  _buildIconWithCounter(_commentLabel, post.commentCount),
                  Spacer(),
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

  Container _buildIconWithCounter(String label, int num) {
    final _labelMap = {
      "favorite": Icons.favorite,
      "comment": Icons.comment,
    };

    return Container(
      child: Row(
        children: [
          Icon(
            _labelMap[label],
            size: 16,
            color: Colors.black12,
          ),
          SizedBox(width: 2),
          Text(
            NumberFormat.compact().format(num),
            style: TextStyle(
              color: AppColor.kPrimaryTextColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // 星の表示切替方法は後々検討する
  Container _buildEvalStars() {
    Icon _getStar(bool isFill) {
      return Icon(
        Icons.star,
        size: 12,
        color: AppColor.kStarYellowColor,
      );
    }

    return Container(
      child: Row(
        children: [
          _getStar(true),
          _getStar(true),
          _getStar(true),
          _getStar(true),
          _getStar(true),
        ],
      ),
    );
  }
}
