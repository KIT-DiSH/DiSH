import 'package:dish/configs/constant_colors.dart';
import 'package:flutter/material.dart';

class HashtagList extends StatefulWidget {
  HashtagList({Key key}) : super(key: key);

  @override
  _HashtagListState createState() => _HashtagListState();
}

class _HashtagListState extends State<HashtagList> {
  int _selectedIndex = -1;

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
            height: 40,
            width: _mediaWidth - _chipListPadding,
            child: ListView.separated(
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  onTapUp: (_) async {
                    // Why: 離すのが早すぎると色が変わらないので.1秒遅らせる
                    await new Future.delayed(
                      new Duration(milliseconds: 100),
                    );
                    setState(() {
                      _selectedIndex = -1;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _selectedIndex = -1;
                    });
                  },
                  child: Chip(
                    label: Text("ねぎ"),
                    backgroundColor: _selectedIndex == index
                        ? AppColor.kPinkColor.withOpacity(0.7)
                        : Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
