import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dish/configs/constant_colors.dart';

class SigninSginupScreen extends StatelessWidget {
  final String _backgroundImagePath = "assets/images/background.png";
  final _facebookIconPath = "assets/images/facebook_logo.svg";
  final _appleIconPath = "assets/images/apple_logo.svg";
  final _googleIconPath = "assets/images/google_logo.svg";
  final _facebookLabel = "Facebookでログイン";
  final _googleLabel = "Googleでログイン";
  final _appleLabel = "Appleでログイン";
  final _mailLabel = "メールアドレスで登録";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            IconWithLabelButton(
              icon: SvgPicture.asset(_facebookIconPath),
              buttonText: _facebookLabel,
              press: () {},
              borderColor: Color(0xFF3C5A9A),
              textColor: Colors.white,
              backgroundColor: Color(0xFF3C5A9A),
            ),
            SizedBox(height: 16),
            IconWithLabelButton(
              icon: SvgPicture.asset(_googleIconPath),
              buttonText: _googleLabel,
              press: () {},
            ),
            SizedBox(height: 16),
            IconWithLabelButton(
              icon: SvgPicture.asset(_appleIconPath),
              buttonText: _appleLabel,
              press: () {},
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.black12,
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "または",
                    style: TextStyle(
                      color: AppColor.kPrimaryTextColor.withOpacity(0.65),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.black12,
                    thickness: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            IconWithLabelButton(
              icon: Icon(
                Icons.mail_outline,
                color: Colors.black26,
                size: 28,
              ),
              buttonText: _mailLabel,
              press: () {},
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "既にアカウントをお持ちですか？",
                  style: TextStyle(
                    color: AppColor.kPrimaryTextColor.withOpacity(0.65),
                  ),
                ),
                TextButton(
                  child: Text("ログイン"),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class IconWithLabelButton extends StatelessWidget {
  const IconWithLabelButton({
    Key? key,
    required this.icon,
    required this.buttonText,
    required this.press,
    this.borderColor = AppColor.kDefaultBorderColor,
    this.textColor = const Color(0xFF6F6F6F),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  final Widget icon;
  final String buttonText;
  final VoidCallback press;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: 3.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: icon,
            ),
            Text(
              buttonText,
              style: TextStyle(color: textColor),
            ),
            SizedBox(
              width: 28,
              height: 28,
            ),
          ],
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
