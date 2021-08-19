import 'package:dish/widgets/profile_screen/action_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:dish/models/User.dart';
import 'package:dish/configs/constant_colors.dart';

class ProfileField extends StatefulWidget {
  ProfileField({
    Key key,
    @required this.user,
  });

  final User user;

  @override
  _ProfileFieldState createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  final _postLabel = "投稿";
  final _followerLabel = "フォロワー";
  final _followLabel = "フォロー";
  final _type = "myself"; // or "followed", "stranger"

  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      height: 65,
                      width: 65,
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
                    SizedBox(height: 8),
                    Text(
                      user.userName,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.kPrimaryTextColor,
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 1),
                Row(
                  children: [
                    _buildNumWithLabel(
                      user.postCount,
                      _postLabel,
                      () {},
                    ),
                    SizedBox(
                      height: 55,
                      child: VerticalDivider(
                        thickness: 1,
                        color: AppColor.kDefaultBorderColor.withOpacity(0.75),
                      ),
                    ),
                    _buildNumWithLabel(
                      user.followerCount,
                      _followerLabel,
                      () {},
                    ),
                    SizedBox(
                      height: 55,
                      child: VerticalDivider(
                        thickness: 1,
                        color: AppColor.kDefaultBorderColor.withOpacity(0.75),
                      ),
                    ),
                    _buildNumWithLabel(
                      user.followCount,
                      _followLabel,
                      () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(
            child: Text(
              user.profileText,
              style: TextStyle(
                fontSize: 12,
                color: AppColor.kPrimaryTextColor,
              ),
            ),
          ),
          SizedBox(height: 24),
          ActionButton(userType: _type),
        ],
      ),
    );
  }

  GestureDetector _buildNumWithLabel(
    int counter,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        child: Column(
          children: [
            Text(
              NumberFormat.compact().format(counter),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColor.kPrimaryTextColor.withOpacity(0.6),
              ),
            )
          ],
        ),
      ),
    );
  }
}
