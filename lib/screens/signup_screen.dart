import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/signin_signup_screen/text_field_with_hint.dart';

class SignupScreen extends StatelessWidget {
  final _title = "DiSHへようこそ！";
  final _backgroundImagePath = "assets/images/background.png";
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_backgroundImagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        _title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 3,
                        ),
                      ),
                      SizedBox(
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                  Spacer(),
                  TextFieldWithHint(
                    controller: _mailController,
                    hintText: "メールアドレス",
                  ),
                  SizedBox(height: 20),
                  TextFieldWithHint(
                    isPassword: true,
                    controller: _passwordController,
                    hintText: "パスワード",
                  ),
                  SizedBox(height: 20),
                  TextFieldWithHint(
                    isPassword: true,
                    controller: _confirmPasswordController,
                    hintText: "パスワード（再入力）",
                  ),
                  SizedBox(height: 20),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        "アカウント作成",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                        minimumSize: MaterialStateProperty.all(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor:
                            MaterialStateProperty.all(AppColor.kPinkColor),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
