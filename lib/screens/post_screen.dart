import 'package:dish/plugins/rich_text_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dish/widgets/common/simple_alert_dialog.dart';
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
  late TextEditingController _restaurantNameController =
      TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  final _initRestaurantName = "場所";

  @override
  void initState() {
    _postTextController = RichTextController(
      patternMap: {
        RegExp(r"#\S*"): TextStyle(color: AppColor.kPinkColor),
      },
      // onMatch: () {print("#だよ");},
    );
    _restaurantNameController.text = _initRestaurantName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _hintText = "投稿文を書く";
    final _maxLength = 250;

    void changeResName(String name) {
      setState(() {
        if (name == "") {
          _restaurantNameController.text = _initRestaurantName;
        } else {
          _restaurantNameController.text = name;
        }
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
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          child: TextFormField(
                            readOnly: true,
                            controller: _restaurantNameController,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headline6,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == _initRestaurantName) {
                                return "場所を選択してください";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          child: TextFormField(
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value?.length == 0) {
                                return "投稿文を記入してください";
                              }
                              return null;
                            },
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
        onPressed: () async {
          // 動作確認用として if で切り分けてる
          // フッターを非表示にする場合は if を削除する
          // if (Navigator.of(context).canPop()) Navigator.pop(context);
          final result = await showDialog(
            context: context,
            builder: (_) {
              return SimpleAlertDialog(
                title: "警告",
                content: "編集中の内容が削除されますがよろしいですか",
              );
            },
          );
          if (result) {
            // 途中の投稿を保存する処理
            Navigator.pop(context);
          }
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
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
            }
            // ここで投稿作成の処理
          },
        ),
      ],
    );
  }
}
