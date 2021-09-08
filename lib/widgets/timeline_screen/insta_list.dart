import 'package:dish/configs/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class User {
  String id;
  String name;
  String imageUrl;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class Comment {
  User user;
  String text;

  Comment({
    required this.user,
    required this.text,
  });
}

class PostModel {
  bool isTextExpanded;
  bool isCommentExpanded;
  int star;
  String image;
  User user;
  String shop;
  String discription;
  String tags;
  String map;
  List<Comment> comments;

  PostModel({
    this.isTextExpanded: false,
    this.isCommentExpanded: false,
    required this.star,
    required this.image,
    required this.user,
    required this.shop,
    required this.discription,
    required this.tags,
    required this.map,
    required this.comments,
  });
}

List<PostModel> posts = [
  PostModel(
    star: 3,
    image: 'https://picsum.photos/600',
    user: User(
      id: 'aaa',
      name: 'kaito',
      imageUrl: 'https://picsum.photos/40',
    ),
    shop: '馬肉専門店　うまうま王国',
    discription: 'おいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそう',
    tags: '#馬うますぎて草 #有馬記念',
    map: 'https://amazom.com',
    comments: ([
      Comment(
        user: User(
          id: '',
          name: 'fujimura',
          imageUrl: 'https://picsum.photos/42',
        ),
        text: '美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった',
      ),
      Comment(
        user: User(
          id: '',
          name: 'fujimura',
          imageUrl: 'https://picsum.photos/44',
        ),
        text: '美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった',
      ),
    ]),
  ),
  PostModel(
    star: 4,
    image: 'https://picsum.photos/601',
    user: User(
      id: 'aaa',
      name: 'fuji',
      imageUrl: 'https://picsum.photos/41',
    ),
    shop: '羊肉専門店　メーメー王国',
    discription: 'おいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそうおいしそう',
    tags: '#羊うますぎて草 #有馬記念',
    map: 'https://amazom.com',
    comments: ([
      Comment(
        user: User(
          id: '',
          name: 'kaitoooo',
          imageUrl: 'https://picsum.photos/43',
        ),
        text: '美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった',
      ),
      Comment(
        user: User(
          id: '',
          name: 'fujiiiiii',
          imageUrl: 'https://picsum.photos/45',
        ),
        text: '美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった美味しかった',
      ),
    ]),
  ),
];

class InstaList extends StatefulWidget {
  @override
  _InstaListState createState() => _InstaListState();
}

class _InstaListState extends State<InstaList> {
  @override
  Widget build(BuildContext context) {
    // var devicesize = MediaQuery.of(context).size;
    const IconData star = IconData(0xe5f9, fontFamily: 'MaterialIcons');

    return new ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1st row
          Flexible(
            fit: FlexFit.loose,
            child: new Image.network(
              posts[index].image,
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
                            posts[index].user.imageUrl,
                          ),
                        ),
                      ),
                    ),
                    new SizedBox(width: 10),
                    Column(
                      children: [
                        new Text(
                          posts[index].user.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (int i = 0; i < posts[index].star; i++)
                              new Icon(
                                star,
                              ),
                            for (int i = 0; i < 5 - posts[index].star; i++)
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 4.0,
                                ),
                                child: SizedBox(
                                  child: new Icon(
                                    FontAwesomeIcons.star,
                                    size: 16,
                                  ),
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3rd row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  posts[index].shop,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),

          // 4th row
          GestureDetector(
            onTap: () {
              setState(() {
                posts[index].isTextExpanded = !posts[index].isTextExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                posts[index].discription,
                maxLines: posts[index].isTextExpanded ? 1000 : 2,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                Text(
                  posts[index].tags,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),

          // 6th row
          GestureDetector(
            onTap: () {
              // コメント画面に遷移
              print('コメント画面に遷移');
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Text(
                'コメントを全て見る',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
