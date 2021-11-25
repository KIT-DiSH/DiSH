import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dish/widgets/routes/route.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/signin_signup_screen/text_field_with_hint.dart';

class SetupAccountScreen extends StatefulWidget {
  const SetupAccountScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _SetupAccountScreenState createState() => _SetupAccountScreenState();
}

class _SetupAccountScreenState extends State<SetupAccountScreen> {
  final _title = "アカウント作成";
  final _backgroundImagePath = "assets/images/background.png";
  final _userNameController = TextEditingController();
  final _userIDController = TextEditingController();
  String _iconPath =
      "https://i.pinimg.com/474x/9b/47/a0/9b47a023caf29f113237d61170f34ad9.jpg";

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Row(
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
                    ),
                    Spacer(),
                    Container(
                      height: 112,
                      width: 112,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.kPinkColor,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(999)),
                        child: Image.network(
                          _iconPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // 画像を選択する処理
                      },
                      child: Text(
                        "画像を選択する",
                        style: TextStyle(
                          color: AppColor.kPrimaryTextColor.withOpacity(0.75),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFieldWithHint(
                      controller: _userNameController,
                      hintText: "名前",
                    ),
                    SizedBox(height: 20),
                    TextFieldWithHint(
                      controller: _userIDController,
                      hintText: "ユーザーID",
                    ),
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
                          backgroundColor:
                              MaterialStateProperty.all(AppColor.kPinkColor),
                        ),
                        onPressed: () async {
                          final String res = await _setupNewAccount(widget.uid);
                          if (res == "success") {
                            print("🍥 SUCCESS");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RouteWidget(),
                              ),
                            );
                          } else {
                            print("💣 Something went wrong => $res");
                          }
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
      ],
    );
  }

  Future<String> _setupNewAccount(String uid) async {
    CollectionReference<Map<String, dynamic>> collectionRef =
        FirebaseFirestore.instance.collection("USERS");
    Future<String> res = collectionRef
        .doc(uid)
        .set({
          "profile_text": "DiSH始めました!!",
          "icon_path": _iconPath,
          "user_id": _userIDController.text,
          "user_name": _userNameController.text,
        })
        .then((value) => "success")
        .catchError((e) => "fail: $e");
    return res;
  }
}
