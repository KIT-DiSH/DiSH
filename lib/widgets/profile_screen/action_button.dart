import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class ActionButton extends StatefulWidget {
  ActionButton({
    Key key,
    @required this.userType,
    @required this.setUserType,
  });

  final String userType;
  final void Function(String) setUserType;

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  final _myselfLabel = "プロフィールを編集する";
  final _followedLabel = "フォロー解除する";
  final _strangerLabel = "フォローする";

  @override
  Widget build(BuildContext context) {
    final _setUserType = widget.setUserType;
    String _userType = widget.userType;

    switch (_userType) {
      case "myself":
        return Container(
          height: 36,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColor.kDefaultBorderColor),
          ),
          child: TextButton(
            child: Text(
              _myselfLabel,
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
              // プロフィール編集画面へ遷移
              print("edit profile");
            },
          ),
        );
        break;
      case "followed":
        {
          return Container(
            height: 36,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: AppColor.kDefaultBorderColor),
            ),
            child: TextButton(
              child: Text(
                _followedLabel,
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
                setState(() {
                  // フォロー解除処理
                  _setUserType("stranger");
                  print("unfollowed");
                });
              },
            ),
          );
        }
        break;
      case "stranger":
        {
          return Container(
            height: 36,
            width: double.infinity,
            child: TextButton(
              child: Text(
                _strangerLabel,
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: AppColor.kPinkColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              onPressed: () {
                setState(() {
                  // フォロー処理
                  _setUserType("followed");
                  print("followed");
                });
              },
            ),
          );
        }
        break;
      default:
        return Container();
    }
  }
}
