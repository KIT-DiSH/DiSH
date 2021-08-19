import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({
    Key key,
    @required this.userType,
  }) : super(key: key);

  final String userType;

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    final userType = widget.userType;
    return Container(
      height: 36,
      width: double.infinity,
      decoration: _buildDecoration(userType),
      child: TextButton(
        child: Text(
          _buildButtonText(userType),
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        style: _buildButtonStyle(userType),
        onPressed: _buildPressFunc(userType),
      ),
    );
  }

  String _buildButtonText(String _type) {
    if (_type == "myself") {
      return "プロフィールを編集する";
    } else if (_type == "followed") {
      return "フォロー解除する";
    } else if (_type == "stranger") {
      return "フォローする";
    } else {
      return "";
    }
  }

  ButtonStyle _buildButtonStyle(String _type) {
    return TextButton.styleFrom(
      primary: _type == "stranger" ? Colors.white : AppColor.kPrimaryTextColor,
      backgroundColor: _type == "stranger" ? AppColor.kPinkColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  VoidCallback _buildPressFunc(String _type) {
    if (_type == "myself") {
      return () {};
    } else if (_type == "followed") {
      return () {};
    } else if (_type == "stranger") {
      return () {};
    } else {
      return () {};
    }
  }

  Decoration _buildDecoration(String _type) {
    if (_type == "stranger") {
      return null;
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: AppColor.kDefaultBorderColor),
      );
    }
  }
}
