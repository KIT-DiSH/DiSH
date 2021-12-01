import 'package:dish/screens/comment_screen.dart';
import 'package:flutter/material.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:dish/models/PostModel.dart';
import 'package:dish/screens/profile_screen.dart';
import 'package:dish/screens/check_places_map.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/timeline_screen/start.dart';

class DishPost extends StatefulWidget {
  final String uid;
  final PostModel postInfo;

  DishPost({
    Key? key,
    required this.uid,
    required this.postInfo,
  });

  @override
  _DishPostState createState() => _DishPostState();
}

class _DishPostState extends State<DishPost> {
  int activeIndex = 0;
  bool favorite = false;
  bool isTextExpanded = false;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1st row
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    height: _width,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) => {
                      setState(() => activeIndex = index),
                    },
                  ),
                  itemCount: widget.postInfo.imageUrls.length,
                  itemBuilder: (context, index, realIndex) {
                    final url = widget.postInfo.imageUrls[index];
                    return buildImage(context, url, index);
                  },
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 12,
                        bottom: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          width: 40,
                          height: 40,
                        ),
                      ),
                      TextButton(
                        child: Icon(
                          favorite == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favorite == true ? Colors.red : Colors.black38,
                        ),
                        onPressed: () {
                          setState(() {
                            if (!favorite)
                              favorite = true;
                            else
                              favorite = false;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            buildIndicator(),
          ],
        ),

        // 2nd row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // 実際には ProfileScreen に UserID を渡すなどして
                  // プロフィールページの中身を決定する
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(uid: widget.uid)),
                  );
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                        widget.postInfo.postUser.iconImageUrl,
                      ),
                    ),
                  ),
                ),
              ),
              new SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(
                    widget.postInfo.postUser.userId,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    width: 100,
                    child: StarReview(
                      rate: widget.postInfo.stars["cost"]!,
                    ),
                  ),
                ],
              ),
              Spacer(),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return CheckPlacesMap(
                          latLng: widget.postInfo.map,
                          uid: widget.uid,
                          fromPost: true,
                        );
                      }),
                    );
                  },
                ),
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
          child: Text(
            widget.postInfo.restName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),

        // 4th row
        GestureDetector(
          onTap: () {
            setState(() {
              isTextExpanded = !isTextExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: RichTextView(
              text: widget.postInfo.content,
              maxLines: isTextExpanded ? 1000 : 2,
              onHashTagClicked: (hashtag) => print('$hashtag push!'),
              style: TextStyle(
                fontSize: 12,
                color: AppColor.kPrimaryTextColor,
              ),
              linkStyle: TextStyle(
                color: Colors.orange,
              ),
            ),
          ),
        ),

        // 5th row
        GestureDetector(
          onTap: () {
            // コメント画面に遷移
            // 実際はコメントの情報を引数として渡す
            print('コメント画面に遷移');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CommentScreen()),
            );
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
    );
  }

  Widget buildImage(BuildContext context, String url, int index) {
    return Container(
      color: Colors.grey,
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.postInfo.imageUrls.length,
        effect: JumpingDotEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: Colors.pink,
          dotColor: Colors.black12,
        ),
      );
}
