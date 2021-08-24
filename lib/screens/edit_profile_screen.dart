import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _userName;
  String _userId;
  String _biography;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                        "アイコンを変更する",
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
              Divider(
                height: 1,
                thickness: 1,
                color: AppColor.kDefaultBorderColor.withOpacity(0.75),
              ),
              // 名前変更エリア
              _buildLabelWithTextField("名前", _width, (String value) {
                setState(() {
                  _userName = value;
                });
              }),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColor.kDefaultBorderColor.withOpacity(0.75),
              ),
              // ユーザーID変更エリア
              _buildLabelWithTextField("ユーザーID", _width, (String value) {
                setState(() {
                  _userId = value;
                });
              }),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColor.kDefaultBorderColor.withOpacity(0.75),
              ),
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
                        "自己紹介",
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
                          onChanged: (String value) {
                            setState(() {
                              _biography = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColor.kDefaultBorderColor.withOpacity(0.75),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(color: Colors.black12),
        child: Center(child: Text("footer")),
      ),
    );
  }

  Container _buildLabelWithTextField(
    String _label,
    double _width,
    void Function(String) _onChanged,
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
              decoration: InputDecoration.collapsed(hintText: _label),
              style: TextStyle(fontSize: 14),
              onChanged: _onChanged,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 9),
            child: TextButton(
              child: Text(
                "保存",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: AppColor.kPinkColor,
                padding: EdgeInsets.all(0),
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
