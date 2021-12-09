import 'package:dish/configs/constant_colors.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    Key? key,
    required this.didFollow,
    required this.followUser,
    required this.unFollowUser,
  }) : super(key: key);

  final bool didFollow;
  final Function followUser;
  final Function unFollowUser;

  @override
  Widget build(BuildContext context) {
    final _followedLabel = "フォロー中";
    final _notFollowedLabel = "フォロー";

    return didFollow
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
                unFollowUser();
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
                followUser();
              },
            ),
          );
  }
}
