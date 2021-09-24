import 'package:dish/plugins/rich_text_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dish/widgets/common/simple_divider.dart';
import 'package:dish/widgets/post_screen/image_list.dart';
import 'package:dish/widgets/post_screen/place_list.dart';
import 'package:dish/widgets/post_screen/hashtag_list.dart';
import 'package:dish/widgets/post_screen/star_review.dart';
import 'package:dish/configs/constant_colors.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late RichTextController _postTextController;

  String restaurantName = "";

  @override
  void initState() {
    _postTextController = RichTextController(
      patternMap: {
        RegExp(r"#\S*"): TextStyle(color: AppColor.kPinkColor),
      },
      // onMatch: () {print("#だよ");},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _hintText = "投稿文を書く";
    final _maxLength = 250;

    void changeResName(String name) {
      setState(() {
        restaurantName = name;
      });
    }

    void addHashtag(String name) {
      setState(() {
        if (_postTextController.text.length + name.length <= _maxLength)
          _postTextController.text += (name + " ");
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        child: Text(
                          restaurantName != "" ? restaurantName : "店名",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 200,
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.multiline,
                          maxLines: 100,
                          controller: _postTextController,
                          maxLength: _maxLength,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _hintText,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                ImageList(),
                const SizedBox(height: 8),
                SimpleDivider(),
                HashtagList(emitHashtag: addHashtag),
                SimpleDivider(),
                PlaceList(emitRestaurantName: changeResName),
                SimpleDivider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      StarReview(sectionName: "料理"),
                      StarReview(sectionName: "雰囲気"),
                      StarReview(sectionName: "コスパ"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final _titleText = "新規投稿";

    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () {
          // 動作確認用として if で切り分けてる
          // フッターを非表示にする場合は if を削除する
          // if (Navigator.of(context).canPop()) Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
      title: Text(_titleText),
      centerTitle: true,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.check,
            color: AppColor.kPinkColor,
          ),
          onPressed: () {
            // ここで投稿作成の処理
          },
        ),
      ],
    );
  }
}
