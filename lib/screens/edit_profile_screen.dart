import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dish/models/User.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/simple_divider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    Key? key,
    required this.uid,
    required this.user,
  }) : super(key: key);

  final String uid;
  final User user;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _iconPath;
  final _userNameController = TextEditingController();
  final _userIdController = TextEditingController();
  final _profileTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _iconPath = widget.user.iconImageUrl;
    _userNameController.text = widget.user.userName;
    _userIdController.text = widget.user.userId;
    _profileTextController.text = widget.user.profileText;
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _changeIconLabel = "アイコンを変更する";
    final _userNameLabel = "名前";
    final _userIdLabel = "ユーザーID";
    final _biographyLabel = "自己紹介";

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // アイコン変更エリア
                Container(
                  width: double.infinity,
                  height: 168,
                  decoration: BoxDecoration(color: Color(0xFFFBFBFB)),
                  child: Column(
                    children: [
                      Spacer(),
                      Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.kPinkColor,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Image.network(
                            widget.user.iconImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          AssetPicker.pickAssets(
                            context,
                            maxAssets: 1,
                            textDelegate: JapaneseTextDelegate(),
                            themeColor: AppColor.kPinkColor,
                            requestType: RequestType.image,
                          ).then(
                            (assets) async => {
                              // if (assets != null)
                              //   {
                              //     await Future.forEach(
                              //       assets,
                              //       (AssetEntity asset) async {
                              //         _tmpFiles.add((await asset.file)!);
                              //       },
                              //     ),
                              //     setState(() {
                              //       selectedAssets = assets;
                              //     }),
                              //     widget.updateImageFiles(_tmpFiles),
                              //   },
                            },
                          );
                        },
                        child: Text(
                          _changeIconLabel,
                          style: TextStyle(
                            color: AppColor.kPrimaryTextColor.withOpacity(0.75),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                SimpleDivider(height: 1.0),
                // 名前変更エリア
                _buildLabelWithTextField(
                    _userNameLabel, _width, _userNameController),
                SimpleDivider(height: 1.0),
                // ユーザーID変更エリア
                _buildLabelWithTextField(
                    _userIdLabel, _width, _userIdController),
                SimpleDivider(height: 1.0),
                // 自己紹介変更エリア
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          _biographyLabel,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            maxLength: 200,
                            decoration: InputDecoration.collapsed(hintText: ""),
                            style: TextStyle(fontSize: 14),
                            controller: _profileTextController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SimpleDivider(height: 1.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildLabelWithTextField(
    String _label,
    double _width,
    TextEditingController _controller,
  ) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _width * 0.35 - 25,
            child: Text(
              _label,
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            width: _width * 0.65 - 25,
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: _label,
                hintStyle: TextStyle(
                  color: AppColor.kPrimaryTextColor.withOpacity(0.6),
                ),
              ),
              style: TextStyle(fontSize: 14),
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final String _preserveText = "保存";

    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 1.0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 9),
          child: TextButton(
            child: Text(
              _preserveText,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: AppColor.kPinkColor,
              padding: EdgeInsets.all(0),
            ),
            onPressed: _clickSaveButton,
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Future<void> _clickSaveButton() async {
    String res;
    User user = widget.user;
    String userId = _userIdController.text;
    String userName = _userNameController.text;
    String profileText = _profileTextController.text;

    if (userId == user.userId &&
        userName == user.userName &&
        _iconPath == user.iconImageUrl &&
        profileText == user.profileText) {
      Navigator.pop(context);
      return;
    }

    if (userId == "") userId = widget.user.userId;
    if (userName == "") userName = widget.user.userName;
    if (_iconPath == "" || _iconPath == null)
      _iconPath = widget.user.iconImageUrl;

    final bool isAvailableId = await _checkAvailableUserId(widget.uid);

    if (isAvailableId) {
      res = await _editProfileInfo(
        widget.uid,
        userId,
        userName,
        _iconPath!,
        profileText,
      );
    } else {
      // 既に使用されたIDを登録しようとしている
      // ここでバリデーションテキストを出してほしい
      print("This USER ID is duplicated...");
      return;
    }

    if (res == "success") {
      print("🍥 SUCCESS");
      Navigator.pop(context);
    } else {
      print("💣 Something went wrong => $res");
    }
  }

  Future<bool> _checkAvailableUserId(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseFirestore
        .instance
        .collection("USERS")
        .where("user_id", isEqualTo: _userIdController.text)
        .get();
    final int length = snapshots.docs.length;
    if (length > 1) {
      return false;
    } else if (length == 1) {
      final String userId = snapshots.docs.first.data()["user_id"];
      if (userId != widget.user.userId) return false;
    }
    return true;
  }

  Future<String> _editProfileInfo(
    String uid,
    String userId,
    String userName,
    String iconPath,
    String profileText,
  ) async {
    DocumentReference<Map<String, dynamic>> documentRef =
        FirebaseFirestore.instance.collection("USERS").doc(uid);
    Future<String> res = documentRef
        .set(
          {
            "user_id": userId,
            "user_name": userName,
            "icon_path": _iconPath,
            "profile_text": profileText,
          },
          SetOptions(merge: true),
        )
        .then((value) => "success")
        .catchError((e) => "fail: $e");
    return res;
  }
}
