import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dish/screens/signup_screen.dart';
import 'package:dish/screens/signin_screen.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/divider_with_label.dart';
import 'package:dish/widgets/signin_signup_screen/icon_with_label_button.dart';

class SelectSigninSginupScreen extends StatelessWidget {
  final _backgroundImagePath = "assets/images/background.png";
  final _facebookIconPath = "assets/images/facebook_logo.svg";
  final _googleIconPath = "assets/images/google_logo.svg";
  final _appleIconPath = "assets/images/apple_logo.svg";
  final _facebookLabel = "Facebookでログイン";
  final _googleLabel = "Googleでログイン";
  final _appleLabel = "Appleでログイン";
  final _mailLabel = "メールアドレスで登録";

  VoidCallback? _onPressFacebook() {
    // Facebookのログイン処理
  }
  VoidCallback? _onPressGoogle() {
    // Googleのログイン処理
  }
  VoidCallback? _onPressApple() {
    // Appleのログイン処理
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_backgroundImagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                IconWithLabelButton(
                  icon: SvgPicture.asset(_facebookIconPath),
                  buttonText: _facebookLabel,
                  press: _onPressFacebook,
                  borderColor: Color(0xFF3C5A9A),
                  textColor: Colors.white,
                  backgroundColor: Color(0xFF3C5A9A),
                ),
                const SizedBox(height: 16),
                IconWithLabelButton(
                  icon: SvgPicture.asset(_googleIconPath),
                  buttonText: _googleLabel,
                  press: _onPressGoogle,
                ),
                const SizedBox(height: 16),
                IconWithLabelButton(
                  icon: SvgPicture.asset(_appleIconPath),
                  buttonText: _appleLabel,
                  press: _onPressApple,
                ),
                const SizedBox(height: 40),
                DividerWithLabel(label: "または"),
                const SizedBox(height: 40),
                IconWithLabelButton(
                  icon: Icon(
                    Icons.mail_outline,
                    color: Colors.black26,
                    size: 28,
                  ),
                  buttonText: _mailLabel,
                  press: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignupScreen(),
                      ),
                    ),
                  },
                ),
                const SizedBox(height: 8),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SigninScreen(),
                          ),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
