import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/dummy/dummy_places.dart';
import 'package:dish/widgets/post_screen/specify_pin_map.dart';

class PlaceList extends StatefulWidget {
  final emitRestaurantName;
  PlaceList({Key? key, required Function this.emitRestaurantName})
      : super(key: key);

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  int _selectedIndex = -1;

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
                  itemCount: dummyPlaces.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (BuildContext context, int index) {
                    return FilterChip(
                      label: Text(
                        index == dummyPlaces.length
                            ? "場所を指定"
                            : dummyPlaces[index],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      selected: index == _selectedIndex,
                      selectedColor: AppColor.kPinkColor.withOpacity(0.7),
                      showCheckmark: false,
                      pressElevation: 1,
                      onSelected: (selected) {
                        if (index == dummyPlaces.length) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) {
                              return SpecifyPinMap();
                            }),
                          );
                        } else {
                          setState(() {
                            _selectedIndex = selected ? index : -1;
                          });
                          var _resName = selected ? dummyPlaces[index] : "";
                          widget.emitRestaurantName(_resName);
                        }
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
