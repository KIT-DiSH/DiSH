import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

import 'package:dish/plugins/rich_text_controller.dart';
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
  TextEditingController _restaurantNameController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  final _initRestaurantName = "場所";
  final _initRating = 3.0;
  List<File> selectedImageFiles = [];
  late double foodRate = _initRating;
  late double atmRate = _initRating;
  late double costRate = _initRating;
  String uid = FirebaseAuth.instance.currentUser!.uid;

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

    void updateResName(String name) {
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

    void updateSelectedImageFiles(List<File> files) {
      setState(() {
        selectedImageFiles = files;
      });
    }

    void updateRating(double rating, String section) {
      setState(() {
        switch (section) {
          case "料理":
            foodRate = rating;
            break;
          case "雰囲気":
            atmRate = rating;
            break;
          case "コスパ":
            costRate = rating;
            break;
        }
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
                  ImageList(
                    selectedImageFiles: selectedImageFiles,
                    updateImageFiles: updateSelectedImageFiles,
                  ),
                  const SizedBox(height: 8),
                  SimpleDivider(),
                  HashtagList(addHashtag: addHashtag),
                  SimpleDivider(),
                  PlaceList(updateResName: updateResName),
                  SimpleDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        StarReview(
                          sectionName: "料理",
                          rating: foodRate,
                          updateRating: updateRating,
                        ),
                        StarReview(
                          sectionName: "雰囲気",
                          rating: atmRate,
                          updateRating: updateRating,
                        ),
                        StarReview(
                          sectionName: "コスパ",
                          rating: costRate,
                          updateRating: updateRating,
                        ),
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

  // void _uploadImages(String uid, List<File> files) async {
  //   // String uid = "uruCi5pw8gWNOQeudRWfYiQ8Age2";
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   try {
  //     await storage.ref("post_images/$uid").putFile(files[0]);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  AppBar _buildAppBar(BuildContext context) {
    final _titleText = "新規投稿";

    bool checkIsEdited() {
      if (selectedImageFiles.isEmpty &&
          _restaurantNameController.text == _initRestaurantName &&
          _postTextController.text.isEmpty &&
          foodRate == _initRating &&
          atmRate == _initRating &&
          costRate == _initRating) {
        return false;
      }
      return true;
    }

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
          if (checkIsEdited()) {
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
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: Text(
        _titleText,
        style: TextStyle(color: AppColor.kPrimaryTextColor),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColor.kWhiteColor,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.check,
            color: AppColor.kPinkColor,
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
            }
            // ここで投稿作成の処理
            // await _uploadImages(uid, selectedImageFiles);
            await addNewPost(uid, _postTextController.value.text,
                _restaurantNameController.value.text, {
              "lat": 37.42796133580664,
              "lng": -122.085749655962,
            }, {
              "cost": costRate,
              "mood": atmRate,
              "taste": foodRate,
            }, [
              "https://d3bhdfps5qyllw.cloudfront.net/org/57/57fb3c11bb13ae10b47d540120fae536_1242x1242_w.jpg",
              "https://d3bhdfps5qyllw.cloudfront.net/org/57/57fb3c11bb13ae10b47d540120fae536_1242x1242_w.jpg",
            ]);
          },
        ),
      ],
    );
  }

  Future<String> addNewPost(
    String uid,
    String content,
    String restaurantName,
    Map<String, double> location,
    Map<String, double> evaluation,
    List<String> imagePaths,
  ) async {
    CollectionReference<Map<String, dynamic>> collectionRef =
        FirebaseFirestore.instance.collection("USERS/$uid/POSTS");
    Future<String> res = collectionRef
        .add({
          "uid": uid,
          "content": content,
          "restaurant_name": restaurantName,
          "location": location,
          "evaluation": evaluation,
          "image_paths": imagePaths,
          "timestamp": DateTime.now(),
        })
        .then((value) => "success")
        .catchError((e) => "fail: $e");
    return res.toString();
  }
}
