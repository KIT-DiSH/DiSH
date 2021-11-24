import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/routes/route.dart';
import 'package:dish/widgets/signin_signup_screen/text_field_with_hint.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _title = "DiSHへようこそ！";
  final _backgroundImagePath = "assets/images/background.png";
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  String signupMessage = '';

  Future<String> signUpWithEmail() async {
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
      return e.code;
    } catch (e) {
      return 'error';
    }
  }

  Future onSignup(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    String signupState = await signUpWithEmail();
    switch (signupState) {
      case 'success':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RouteWidget(),
          ),
        );
        break;
      case 'weak-password':
        setState(() {
          signupMessage = 'このパスワードはすぐに推測されます';
        });
        break;
      case 'email-already-in-use':
        setState(() {
          signupMessage = 'このメールアドレスはすでに使用されています';
        });
        break;
      default:
        setState(() {
          signupMessage = '予期せぬエラーが発生しました';
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
                    padding: const EdgeInsets.only(top: 100),
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
                        if (signupMessage != '')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              signupMessage,
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
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(14)),
                              minimumSize: MaterialStateProperty.all(Size.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: MaterialStateProperty.all(
                                  AppColor.kPinkColor),
                            ),
                            onPressed: () async {
                              await onSignup(context);
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
