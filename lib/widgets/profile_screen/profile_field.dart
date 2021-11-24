import 'package:dish/screens/select_signin_signup_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

import 'package:dish/models/User.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/screens/follow_list_screen.dart';
import 'package:dish/screens/follower_list_screen.dart';
import 'package:dish/widgets/profile_screen/action_button.dart';

class ProfileField extends StatefulWidget {
  ProfileField({
    Key? key,
    required this.user,
  });

  final User user;

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

  Future signOut() async {
    try {
      await firebaseAuth.FirebaseAuth.instance.signOut();
      print('ログアウト成功');
    } catch (e) {
      print('ログアウトエラー');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          return FollowerListScreen();
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
                          return FollowListScreen();
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
          Text(
            user.profileText,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.kPrimaryTextColor,
            ),
          ),
          const SizedBox(height: 24),
          // ボタン
          ActionButton(userType: _userType, setUserType: setUserType),
          // 一時的なログアウトボタン
          Container(
            height: 36,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: AppColor.kDefaultBorderColor),
            ),
            child: TextButton(
              child: Text(
                'ログアウト',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              style: TextButton.styleFrom(
                primary: AppColor.kPrimaryTextColor,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              onPressed: () {
                signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectSigninSignupScreen(),
                  ),
                );
              },
            ),
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
