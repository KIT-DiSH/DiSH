import 'package:flutter/material.dart';

class HashtagList extends StatelessWidget {
  const HashtagList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mediaWidth = MediaQuery.of(context).size.width;
    final _outerPadding = 16;
    final _chipListPadding = _outerPadding + 8 + 40;

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        children: <Widget>[
          Row(
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
                    return Align(
                      child: GestureDetector(
                        onTap: () {},
                        child: Chip(
                          label: Text("aaa"),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          backgroundColor: Colors.white,
                          elevation: 2,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
