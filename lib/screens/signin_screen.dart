import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/signin_signup_screen/text_field_with_hint.dart';

class SigninScreen extends StatelessWidget {
  final _title = "おかえりなさい！";
  final _backgroundImagePath = "assets/images/background.png";
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signInWithEmail() async {
    print(_mailController.text);
    print(_passwordController.text);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _mailController.text, password: _passwordController.text);
      final User user = userCredential.user!;
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return 'firebase error';
    } catch (e) {
      print(e);
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
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        "ログイン",
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
                        String res = await signInWithEmail();
                        if (res == 'success')
                          print('サインイン成功');
                        else
                          print('サインイン失敗');
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
