import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/timeline_screen/start.dart';
import 'package:flutter/material.dart';
import 'package:dish/models/PostModel.dart';

class InstaList extends StatefulWidget {
  @override
  _InstaListState createState() => _InstaListState();
}

class _InstaListState extends State<InstaList> {
  @override
  Widget build(BuildContext context) {
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
                        posts[index].user.imageUrl,
                      ),
                    ),
                  ),
                ),
                new SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Text(
                      posts[index].user.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    Container(
                      width: 100,
                      child: StarReview(
                        rate: posts[index].star + .0,
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
              posts[index].shop,
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
            child: Text(
              posts[index].tags,
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
      ),
    );
  }
}
