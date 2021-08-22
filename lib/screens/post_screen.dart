import 'package:dish/widgets/common/simple_divider.dart';
import 'package:dish/widgets/post_screen/image_list.dart';
import 'package:flutter/material.dart';

import 'package:dish/widgets/post_screen/place_list.dart';
import 'package:dish/widgets/post_screen/hashtag_list.dart';
import 'package:dish/widgets/post_screen/star_review.dart';
import 'package:dish/configs/constant_colors.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleText = "新規投稿";
    final _hintText = "投稿文を書く";
    final _restaurantName = "";

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
                          _restaurantName != "" ? _restaurantName : "店名",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Container(
                        height: 200,
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
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
                HashtagList(),
                SimpleDivider(),
                PlaceList(),
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
}
