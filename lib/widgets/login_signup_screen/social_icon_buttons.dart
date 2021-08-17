import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIconButtons extends StatelessWidget {
  final String _facebookIconPath = "assets/images/facebook_logo.svg";
  final String _appleIconPath = "assets/images/apple_logo.svg";
  final String _googleIconPath = "assets/images/google_logo.svg";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getSocialIconButton(_facebookIconPath, () {}),
          SizedBox(width: 24),
          getSocialIconButton(_appleIconPath, () {}),
          SizedBox(width: 24),
          getSocialIconButton(_googleIconPath, () {}),
        ],
      ),
    );
  }

  Container getSocialIconButton(iconPath, press) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            spreadRadius: 1.2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: TextButton(
        onPressed: press,
        child: SvgPicture.asset(
          iconPath,
          width: 32,
          height: 32,
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
