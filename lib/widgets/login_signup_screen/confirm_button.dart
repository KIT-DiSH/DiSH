import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    Key key,
    @required this.selectedTab,
    @required this.press,
  }) : super(key: key);

  final String selectedTab;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: TextButton(
        child: Text(
          selectedTab == "login" ? "ログイン" : "新規登録",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: AppColor.kPinkColor,
          shape: const StadiumBorder(),
        ),
        onPressed: press,
      ),
    );
  }
}
