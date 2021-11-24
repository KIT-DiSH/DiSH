import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'dart:math';

import 'package:dish/screens/signup_screen.dart';
import 'package:dish/screens/signin_screen.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/divider_with_label.dart';
import 'package:dish/widgets/signin_signup_screen/icon_with_label_button.dart';
import 'package:dish/widgets/routes/route.dart';

class SelectSigninSignupScreen extends StatefulWidget {
  @override
  _SelectSigninSignupScreenState createState() =>
      _SelectSigninSignupScreenState();
}

class _SelectSigninSignupScreenState extends State<SelectSigninSignupScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _backgroundImagePath = "assets/images/background.png";
  final _facebookIconPath = "assets/images/facebook_logo.svg";
  final _appleIconPath = "assets/images/apple_logo.svg";
  final _googleIconPath = "assets/images/google_logo.svg";
  final _facebookLabel = "Facebookでログイン";
  final _googleLabel = "Googleでログイン";
  final _appleLabel = "Appleでログイン";
  final _mailLabel = "メールアドレスで登録";

  Future _onPressFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final User user =
          (await _auth.signInWithCredential(facebookAuthCredential)).user!;

      return user;
    } catch (e) {
      print('facebookログインエラー');
      print(e);
      return null;
    }
  }

  Future _onPressGoogle() async {
    try {
      GoogleSignInAccount? googleCurrentUser = await _googleSignIn.signIn();
      print(googleCurrentUser);
      if (googleCurrentUser == null) return null;

      GoogleSignInAuthentication googleAuth =
          await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User user = (await _auth.signInWithCredential(credential)).user!;

      return user;
    } catch (e) {
      print('googleログインエラー');
      print(e);
      return null;
    }
  }

  Future _onPressApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      final User user =
          (await FirebaseAuth.instance.signInWithCredential(oauthCredential))
              .user!;

      return user;
    } catch (e) {
      print('appleログインエラー');
      print(e);
      return null;
    }
  }

  void checkLoginAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('ログアウト中');
      } else {
        print('ログイン中');
        print(user);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RouteWidget(),
          ),
        );
      }
    });
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  void initState() {
    checkLoginAuth();
    super.initState();
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
