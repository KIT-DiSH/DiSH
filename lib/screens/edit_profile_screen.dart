import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/simple_divider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _userNameController = TextEditingController(text: "苗字名前");
  final _userIdController = TextEditingController(text: "sample_id");
  final _biographyController = TextEditingController(text: "GG Guys.");

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
                            "https://i.pinimg.com/474x/9b/47/a0/9b47a023caf29f113237d61170f34ad9.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          // 画像を選択する処理
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
                            controller: _biographyController,
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
    const _preserveText = "保存";

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
            onPressed: () {
              // プロフィール編集処理
              print(_userNameController.text);
              print(_userIdController.text);
              print(_biographyController.text);
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
