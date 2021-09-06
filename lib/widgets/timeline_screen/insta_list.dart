import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/timeline_screen/expansion_panel.dart';
import 'package:dish/widgets/timeline_screen/insta_stories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:dish/widgets/timeline_screen/expansion_panel.dart';
import 'package:dish/configs/constant_colors.dart';

class User {
  String id;
  String name;
  String imageUrl;

  User({
    this.id,
    this.name,
    this.imageUrl,
  });
}

class Comment {
  User user;
  String text;

  Comment({
    this.user,
    this.text,
  });
}

class PostModel {
  bool isTextExpanded;
  bool isCommentExpanded;
  int star;
  // ここは本当はユーザーモデル
  User user;
  String shop;
  String discription;
  String tags;
  String map;

  PostModel({
    this.isTextExpanded: false,
    this.isCommentExpanded: false,
    this.star,
    this.user,
    this.shop,
    this.discription,
    this.tags,
    this.map,
  });
}

class InstaList extends StatefulWidget {
  @override
  _InstaListState createState() => _InstaListState();
}

class _InstaListState extends State<InstaList> {
  bool _isTextDisplay = false;
  bool _isCommentDisplay = false;

  @override
  Widget build(BuildContext context) {
    // var devicesize = MediaQuery.of(context).size;
    const IconData star = IconData(0xe5f9, fontFamily: 'MaterialIcons');

    return new ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => index == 0
          ? new SizedBox(
              // ストーリを表示する位置
              child: new Container(),
              height: 0,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1st row
                Flexible(
                  fit: FlexFit.loose,
                  child: new Image.network(
                    'https://picsum.photos/600',
                    fit: BoxFit.cover,
                  ),
                ),

                // 2nd row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          new Container(
                            height: 40,
                            width: 40,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                  'https://picsum.photos/40',
                                ),
                              ),
                            ),
                          ),
                          new SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              new Text(
                                "kaito",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < 5; i++)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 4.0,
                                      ),
                                      child: new Icon(
                                        FontAwesomeIcons.star,
                                        size: 8,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: ElevatedButton.icon(
                              label: const Text('マップで見る'),
                              icon: const Icon(
                                Icons.arrow_left,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: AppColor.kPinkColor,
                                onPrimary: Colors.white,
                              ),
                              onPressed: () {
                                print('マップで開く');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3rd row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '馬肉専門店',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'うまうま王国',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // 4th row
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isTextDisplay = !_isTextDisplay;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト',
                      maxLines: _isTextDisplay ? 1000 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.kPrimaryTextColor,
                      ),
                    ),
                  ),
                ),

                // 5th row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: Row(
                    children: [
                      Text(
                        '#馬うますぎて草',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '#有馬記念',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

                // 6th row
                Container(
                  child: ExpansionPanelList(
                    animationDuration: Duration(
                      milliseconds: 500,
                    ),
                    elevation: 1,
                    dividerColor: Color(0xFFF8FAF8),
                    expandedHeaderPadding: EdgeInsets.all(8),
                    children: [
                      ExpansionPanel(
                        backgroundColor: Color(0xFFF8FAF8),
                        body: Container(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // コメントの中→このRowをコメント数分だけ
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new Container(
                                    height: 40,
                                    width: 40,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                          'https://picsum.photos/40',
                                        ),
                                      ),
                                    ),
                                  ),
                                  new SizedBox(
                                    width: 12,
                                  ),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isCommentDisplay =
                                              !_isCommentDisplay;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 8),
                                        child: Text(
                                          'テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト',
                                          maxLines:
                                              _isCommentDisplay ? 1000 : 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.kPrimaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new Container(
                                    height: 40,
                                    width: 40,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                          'https://picsum.photos/40',
                                        ),
                                      ),
                                    ),
                                  ),
                                  new SizedBox(
                                    width: 12,
                                  ),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isCommentDisplay =
                                              !_isCommentDisplay;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 8),
                                        child: Text(
                                          'テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト',
                                          maxLines:
                                              _isCommentDisplay ? 1000 : 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.kPrimaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                onPressed: () {
                                  // コメントページに遷移
                                },
                                child: const Text(
                                  'コメントを全て見る',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),

                              // Flutter1.22以降のみ
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  child: const Text(
                                    'コメントをしてみましょう',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          18.0,
                                        ),
                                        side: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    // コメントページに遷移
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Container(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'コメント',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                        isExpanded: _isTextDisplay,
                      ),
                    ],
                    expansionCallback: (int item, bool status) {
                      setState(
                        () {
                          _isTextDisplay = !_isTextDisplay;
                        },
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
