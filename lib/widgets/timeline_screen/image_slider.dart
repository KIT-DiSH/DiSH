import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSlideerState createState() => _ImageSlideerState();
}

class _ImageSlideerState extends State<ImageSlider> {
  int activeIndex = 0;
  bool favorite = false;
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
                      favorite == true ? Icons.favorite : Icons.favorite_border,
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
