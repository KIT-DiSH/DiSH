import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:dish/models/User.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/screens/follow_list_screen.dart';
import 'package:dish/screens/follower_list_screen.dart';
import 'package:dish/widgets/profile_screen/action_button.dart';

class ProfileField extends StatefulWidget {
  ProfileField({
    Key? key,
    required this.uid,
    required this.user,
    required this.openFooter,
    required this.closeFooter,
  });

  final String uid;
  final User user;
  final VoidCallback openFooter;
  final VoidCallback closeFooter;

  @override
  _ProfileFieldState createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  final _postLabel = "投稿";
  final _followerLabel = "フォロワー";
  final _followLabel = "フォロー";
  String _userType = "myself"; // or "followed", "stranger"

  void setUserType(String userType) {
    setState(() {
      _userType = userType;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String uid = widget.uid;
    final User user = widget.user;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // アイコン、投稿・フォロワー・アイコン数
          Row(
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
                  const SizedBox(height: 8),
                  Text(
                    user.userName,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.kPrimaryTextColor,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Row(
                children: [
                  _buildNumWithLabel(
                    user.postCount!,
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
                    user.followerCount!,
                    _followerLabel,
                    () {
                      print("Navigate to FollowerListScreen");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) {
                          return FollowerListScreen(
                            uid: widget.uid,
                            openFooter: widget.openFooter,
                            closeFooter: widget.closeFooter,
                          );
                        }),
                      );
                    },
                  ),
                  SizedBox(
                    height: 55,
                    child: VerticalDivider(
                      thickness: 1,
                      color: AppColor.kDefaultBorderColor.withOpacity(0.75),
                    ),
                  ),
                  _buildNumWithLabel(
                    user.followCount!,
                    _followLabel,
                    () {
                      print("Navigate to FollowListScreen");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) {
                          return FollowListScreen(
                            uid: widget.uid,
                            openFooter: widget.openFooter,
                            closeFooter: widget.closeFooter,
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // プロフィールテキスト
          SizedBox(
            width: double.infinity,
            child: Text(
              user.profileText,
              style: TextStyle(
                fontSize: 13,
                color: AppColor.kPrimaryTextColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // ボタン
          ActionButton(
            uid: uid,
            user: user,
            userType: _userType,
            setUserType: setUserType,
          ),
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
      child: SizedBox(
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
            const SizedBox(height: 8),
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
