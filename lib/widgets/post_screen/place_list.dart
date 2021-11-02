import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:dish/apis/get_places.dart';
import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/post_screen/specify_pin_map.dart';

class PlaceList extends StatefulWidget {
  final Function updateResName;
  final List<Place> places;
  PlaceList({Key? key, required this.updateResName, required this.places})
      : super(key: key);

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  int _selectedIndex = -1;
  late List<Place> places = widget.places;
  LatLng currentLatLng = LatLng(
    33.590188,
    130.420685,
  );

  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (posi) => setState(() {
        currentLatLng = new LatLng(posi.latitude, posi.longitude);
      }),
    );
  }

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
            "場所",
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(width: 8),
          SizedBox(
            height: 40,
            width: _mediaWidth - _chipListPadding,
            child: ListView.separated(
              itemCount: places.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (BuildContext context, int index) {
                return FilterChip(
                  label: Text(
                    index == places.length ? "場所を指定" : places[index].name,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  selected: index == _selectedIndex,
                  selectedColor: AppColor.kPinkColor.withOpacity(0.7),
                  showCheckmark: false,
                  pressElevation: 1,
                  onSelected: (selected) async {
                    if (index == places.length) {
                      var placesResult = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) {
                          return SpecifyPinMap(currentLatLng: currentLatLng);
                        }),
                      );
                      if (placesResult != null) {
                        if (placesResult == []) {
                          print("エラーが発生しています。");
                        } else {
                          setState(() {
                            places = placesResult;
                          });
                        }
                      }
                    } else {
                      setState(() {
                        _selectedIndex = selected ? index : -1;
                      });
                      var _resName = selected ? places[index].name : "";
                      widget.updateResName(_resName);
                    }
                  },
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
