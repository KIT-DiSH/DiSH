import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/timeline_screen/insta_stories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';

class InstaList extends StatelessWidget {
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
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: [
                //           new Container(
                //             height: 40,
                //             width: 40,
                //             decoration: new BoxDecoration(
                //               shape: BoxShape.circle,
                //               image: new DecorationImage(
                //                 fit: BoxFit.fill,
                //                 image: new NetworkImage(
                //                     'https://picsum.photos/60'),
                //               ),
                //             ),
                //           ),
                //           new SizedBox(
                //             width: 10,
                //           ),
                //           new Text(
                //             "kaito",
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           )
                //         ],
                //       ),
                //       new IconButton(
                //         icon: Icon(Icons.more_vert),
                //         onPressed: () {},
                //       )
                //     ],
                //   ),
                // ),

                // 2nd row
                Flexible(
                  fit: FlexFit.loose,
                  child: new Image.network(
                    'https://picsum.photos/600',
                    fit: BoxFit.cover,
                  ),
                ),

                // 3rd row
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

                // 4th row
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

                // 5th row
                Padding(
                  padding: const EdgeInsets.all(16),
                  // child: Text(
                  //   'テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 10,
                  //   ),
                  // ),
                  child: ReadMoreText(
                    'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                    trimLines: 2,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),

                // 6th row
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
              ],
            ),
    );
  }
}
