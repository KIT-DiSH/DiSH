import 'package:dish/configs/constant_colors.dart';
import 'package:flutter/material.dart';

class PlaceList extends StatefulWidget {
  PlaceList({Key key}) : super(key: key);

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  int _selectedIndex = 0;

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
                "場所",
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
                    return FilterChip(
                      label: Text("Aコーヒー"),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      selected: index == _selectedIndex,
                      selectedColor: AppColor.kPinkColor.withOpacity(0.7),
                      showCheckmark: false,
                      pressElevation: 1,
                      onSelected: (selected) {
                        setState(() {
                          _selectedIndex = selected ? index : -1;
                        });
                      },
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
