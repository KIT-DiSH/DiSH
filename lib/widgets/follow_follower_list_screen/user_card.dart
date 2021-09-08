import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class UserCard extends StatefulWidget {
  const UserCard({Key? key}) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isFollowed = false;
  final _followedLabel = "フォロー中";
  final _notFollowedLabel = "フォロー";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 12,
      ),
      decoration: BoxDecoration(color: Color(0xFFFBFBFB)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 45,
            width: 45,
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
                "https://i.pinimg.com/474x/9b/47/a0/9b47a023caf29f113237d61170f34ad9.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "苗字 名前",
                style: TextStyle(
                  color: AppColor.kPrimaryTextColor,
                  fontSize: 12,
                ),
              ),
              Text(
                "UserName",
                style: TextStyle(
                  color: AppColor.kPrimaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Spacer(),
          isFollowed
              ? Container(
                  width: 88,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: AppColor.kDefaultBorderColor),
                  ),
                  child: TextButton(
                    child: Text(
                      _followedLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.kPrimaryTextColor.withOpacity(0.7),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black12,
                      backgroundColor: Color(0xFFF5F5F5),
                    ),
                    onPressed: () {
                      setState(() {
                        // フォロー解除処理
                        isFollowed = false;
                      });
                    },
                  ),
                )
              : Container(
                  width: 88,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextButton(
                    child: Text(
                      _notFollowedLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black12,
                      backgroundColor: AppColor.kPinkColor,
                    ),
                    onPressed: () {
                      setState(() {
                        // フォロー処理
                        isFollowed = true;
                      });
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
