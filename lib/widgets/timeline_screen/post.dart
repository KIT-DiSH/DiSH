import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:dish/widgets/timeline_screen/start.dart';
import 'package:dish/configs/constant_colors.dart';

class DishPost extends StatefulWidget {
  final String imageUrl;
  final String userName;
  final int star;
  final String shopName;
  final String description;
  final String tags;

  DishPost({
    required this.imageUrl,
    required this.userName,
    required this.star,
    required this.shopName,
    required this.description,
    required this.tags,
  });

  @override
  _DishPostState createState() => _DishPostState();
}

class _DishPostState extends State<DishPost> {
  int activeIndex = 0;
  bool favorite = false;
  bool isTextExpanded = false;
  final List<String> imgList = [
    'https://picsum.photos/600',
    'https://picsum.photos/601',
    'https://picsum.photos/602',
    'https://picsum.photos/603',
    'https://picsum.photos/604',
    'https://picsum.photos/605',
  ];

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
                  itemCount: imgList.length,
                  itemBuilder: (context, index, realIndex) {
                    final url = imgList[index];
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
              Container(
                height: 40,
                width: 40,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                      widget.imageUrl,
                    ),
                  ),
                ),
              ),
              new SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(
                    widget.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    width: 100,
                    child: StarReview(
                      rate: widget.star + .0,
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
                  onPressed: () {},
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
            widget.shopName,
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
            child: Text(
              widget.description,
              maxLines: isTextExpanded ? 1000 : 2,
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
          child: Text(
            widget.tags,
            style: TextStyle(
              fontSize: 10,
              color: Colors.orange,
            ),
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
        count: imgList.length,
        effect: JumpingDotEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: Colors.pink,
          dotColor: Colors.black12,
        ),
      );
}
