import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleText = "新規投稿";
    final _hintText = "投稿文を書く";
    final _restaurantName = "";
    final _mediaWidth = MediaQuery.of(context).size.width;
    final _outerPadding = 16.0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios),
          title: Text(_titleText),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                color: AppColor.kPinkColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        child: Text(
                          _restaurantName != "" ? _restaurantName : "店名",
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        height: 200,
                        child: TextField(
                          style: TextStyle(
                            color: AppColor.kPrimaryTextColor,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _hintText,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        width: _mediaWidth - _outerPadding * 2,
                        child: ListView.separated(
                          itemCount: 6,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (BuildContext context, int index) {
                            int imageIndex = index % 3 + 1; // dummy用なので削除

                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      insetPadding: EdgeInsets.zero,
                                      child: Container(
                                        width: _mediaWidth,
                                        height: _mediaWidth,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/images/sample$imageIndex.png",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Image(
                                image: AssetImage(
                                  "assets/images/sample$imageIndex.png",
                                ),
                                height: 80,
                                width: 80,
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
