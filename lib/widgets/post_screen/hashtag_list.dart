import 'package:dish/dummy/dummy_hashtags.dart';
import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class HashtagList extends StatefulWidget {
  final addHashtag;
  HashtagList({Key? key, this.addHashtag}) : super(key: key);

  @override
  _HashtagListState createState() => _HashtagListState();
}

class _HashtagListState extends State<HashtagList> {
  @override
  Widget build(BuildContext context) {
    final _mediaWidth = MediaQuery.of(context).size.width;
    final _outerPadding = 16;
    final _chipListPadding = _outerPadding + 8 + 40;

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: <Widget>[
          Text(
            "タグ",
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(width: 8),
          SizedBox(
            height: 35,
            width: _mediaWidth - _chipListPadding,
            child: ListView.separated(
              itemCount: dummyHashtags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  onPressed: () {
                    widget.addHashtag(dummyHashtags[index]);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.kMaterialGrayColor,
                    shape: const StadiumBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      dummyHashtags[index],
                      style: TextStyle(
                        color: AppColor.kPrimaryTextColor,
                      ),
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
