import 'package:flutter/material.dart';

import 'package:dish/screens/sample_screens/new_post_screen.dart';
import 'package:dish/screens/sample_screens/map_screen.dart';
import 'package:dish/screens/sample_screens/profile_screen.dart';
import 'package:dish/screens/sample_screens/search_screen.dart';
import 'package:dish/screens/sample_screens/time_line_screen.dart';

class RouteWidget extends StatefulWidget {
  @override
  _RouteWidgetState createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  int _selectedIndex = 0;
  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [];

  // フッターの順番を明示するためのリスト
  final List _footerItemOrder = [
    "home",
    "search",
    "add",
    "map",
    "profile",
  ];

  // 実装した５つの画面（フッターのやつ）をここで指定する
  final Map _rootWidgetIcons = {
    "home": {
      "icon": Icons.home,
      "route": TimeLineScreen(),
    },
    "search": {
      "icon": Icons.search,
      "route": SearchScreen(),
    },
    "add": {
      "icon": Icons.add_box,
      "route": NewPostScreen(),
    },
    "map": {
      "icon": Icons.place,
      "route": MapScreen(),
    },
    "profile": {
      "icon": Icons.person,
      "route": ProfileScreen(),
    },
  };

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _footerItemOrder.length; i++) {
      _bottomNavigationBarItems.add(_createIcon(_footerItemOrder[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _rootWidgetIcons[_footerItemOrder.asMap()[_selectedIndex]]['route'],
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: _bottomNavigationBarItems,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black38,
        ),
      ),
    );
  }

  BottomNavigationBarItem _createIcon(String key) {
    return BottomNavigationBarItem(
      icon: Icon(_rootWidgetIcons[key]["icon"]),
      label: "",
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
