import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dish/main.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/signin_signup_screen/text_field_with_hint.dart';

class SigninScreen extends ConsumerWidget {
  final _title = "おかえりなさい！";
  final _backgroundImagePath = "assets/images/background.png";
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
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
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                        Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child: Text(
                              "ログイン",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(14)),
                              minimumSize: MaterialStateProperty.all(Size.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: MaterialStateProperty.all(
                                  AppColor.kPinkColor),
                            ),
                            onPressed: () {
                              // ログイン処理
                              Navigator.popUntil(context, (route) => false);
                              context.read(isLoginProvider).state = true;

                              // if (_formKey.currentState!.validate()) {
                              //   // アカウント存在確認処理
                              //   ref.watch(isLoginProvider).state = true;
                              // }
                            },
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
