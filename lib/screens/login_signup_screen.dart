import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:dish/widgets/login_signup_screen/social_icon_buttons.dart';
import 'package:dish/widgets/login_signup_screen/switch_tab_button.dart';
import 'package:dish/widgets/login_signup_screen/confirm_button.dart';
import 'package:dish/widgets/login_signup_screen/input_form.dart';
import 'package:dish/configs/constant_colors.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  String selectedTab = "login";
  String email = "";
  String password = "";
  String confirmPassword = "";

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleCurrentUser = await _googleSignIn.signIn();
      print(googleCurrentUser);
      if (googleCurrentUser == null) {
        return {} as User;
      }

      // auth情報を得る
      GoogleSignInAuthentication googleAuth =
          await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User user = (await _auth.signInWithCredential(credential)).user!;
      print("signed in " + user.displayName.toString());

      return user;
    } catch (e) {
      print('ログインエラーです');
      print(e);
      return {} as User;
    }
  }

  Future<User> signInWithFacebook() async {
    try {
      // 未完成SDKのエラーが起きる
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      // return _auth.signInWithCredential(facebookAuthCredential);
      final User user =
          (await _auth.signInWithCredential(facebookAuthCredential)).user!;
      return user;
    } catch (e) {
      print('facebookログインエラー');
      print(e);
      return {} as User;
    }
  }

  Future signUpWithEmail() async {
    print('値確認');
    print(email);
    print(password);
    try {
      // メール/パスワードでユーザー登録
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 登録したユーザー情報
      final User user = result.user!;
      print("登録OK：${user.email}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      // 登録に失敗した場合
      print("登録NG：${e.toString()}");
    }
  }

  Future signInWithEmail() async {
    print('値確認');
    print(email);
    print(password);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      print('ユーザー情報');
      print(user);
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('ログアウト成功');
    } catch (e) {
      print('ログアウトエラー');
      print(e);
    }
  }

  void setEmail(String email) {
    setState(() {
      this.email = email;
    });
  }

  void setPassword(String password) {
    setState(() {
      this.password = password;
    });
  }

  void setConfirmPassword(String password) {
    setState(() {
      this.confirmPassword = password;
    });
  }

  void switchTab(String selectedTab) {
    setState(() {
      this.selectedTab = selectedTab;
      print(selectedTab);
    });
  }

  void onPressedConfirmButton() async {
    try {
      if (selectedTab == "login") {
        // ログイン処理を書く
        print(selectedTab);
        signInWithEmail();
      } else if (selectedTab == "signup") {
        // 新規登録処理を書く
        print(selectedTab);
        signUpWithEmail();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void checkLoginAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('ログアウト中');
      } else {
        print('ログイン中');
        print(user);
        print(user.displayName.toString() + 'でログインしています');
        // TODO: ページ遷移
      }
    });
  }

  @override
  void initState() {
    checkLoginAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String _backgroundImagePath = "assets/images/background.png";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_backgroundImagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              height: 540,
              margin: EdgeInsets.symmetric(horizontal: 35),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 56),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 4,
                    offset: Offset(0, 0),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SwitchTabButton(switchTab: switchTab),
                  Spacer(flex: 2),
                  InputForm(
                    selectedTab: selectedTab,
                    setEmail: setEmail,
                    setPassword: setPassword,
                    setConfirmPassword: setConfirmPassword,
                  ),
                  Spacer(flex: 2),
                  ConfirmButton(
                    selectedTab: selectedTab,
                    press: onPressedConfirmButton,
                  ),
                  Spacer(flex: 1),
                  Text(
                    "OR",
                    style: TextStyle(
                      color: AppColor.kPrimaryTextColor.withOpacity(0.6),
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                  Spacer(flex: 1),
                  SocialIconButtons(
                    facebookSignIn: signInWithFacebook,
                    appleSignIn: signInWithGoogle,
                    googleSignIn: signInWithGoogle,
                  ),
                  ElevatedButton(
                    child: const Text('ログアウト'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
