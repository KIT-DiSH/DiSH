import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/signin_signup_screen/text_field_with_hint.dart';

class SignupScreen extends StatelessWidget {
  final _title = "DiSHへようこそ！";
  final _backgroundImagePath = "assets/images/background.png";
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signUpWithEmail() async {
    print(_mailController.text);
    print(_passwordController.text);
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: _mailController.text,
        password: _passwordController.text,
      );
      final User user = result.user!;
      print("登録OK：${user.email}");
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return 'firebase error';
    } catch (e) {
      print("登録NG：${e.toString()}");
      return 'error';
    }
  }

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
                      onPressed: () async {
                        String res = await signUpWithEmail();
                        if (res == 'suceess')
                          print('ログイン成功');
                        else
                          print('ログイン失敗');
                      },
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
