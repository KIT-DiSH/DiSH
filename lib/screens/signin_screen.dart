import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/routes/route.dart';
import 'package:dish/widgets/signin_signup_screen/text_field_with_hint.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _title = "おかえりなさい！";
  final _backgroundImagePath = "assets/images/background.png";
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  String signinMessage = '';

  Future<String> signInWithEmail() async {
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
      print(e.code);
      return e.code;
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  Future onSignin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    String loginState = await signInWithEmail();
    switch (loginState) {
      case 'success':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RouteWidget(),
          ),
        );
        break;
      case 'user-not-found':
        // no user for this email
        setState(() {
          signinMessage = 'このメールアドレスは登録されていません';
        });
        break;
      case 'wrong-password':
        // wrong password for this email
        setState(() {
          signinMessage = 'パスワードが間違っています';
        });
        break;
      default:
        setState(() {
          signinMessage = '予期せぬエラーが発生しました';
        });
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
                        if (signinMessage != '')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              signinMessage,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
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
                            onPressed: () async {
                              await onSignin(context);
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
