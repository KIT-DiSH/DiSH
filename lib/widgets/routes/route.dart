import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:dish/screens/check_places_map.dart';
import 'package:dish/screens/post_screen.dart';
import 'package:dish/widgets/routes/tab_navigator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteWidget extends StatefulWidget {
  const RouteWidget({Key? key}) : super(key: key);

  @override
  _RouteWidgetState createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  final List<String> _pageKeys = [
    "Home",
    "Search",
    "NewPost",
    "Map",
    "Profile"
  ];
  final Map<String, IconData> _bottomNaviItems = {
    "Home": Icons.home,
    "Search": Icons.search,
    "NewPost": Icons.add_box,
    "Map": Icons.place,
    "Profile": Icons.person,
  };
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Home": GlobalKey<NavigatorState>(),
    "Search": GlobalKey<NavigatorState>(),
    "NewPost": GlobalKey<NavigatorState>(),
    "Map": GlobalKey<NavigatorState>(),
    "Profile": GlobalKey<NavigatorState>(),
  };
  String _currentPage = "Home";

  Future<void> _selectTab(String tabItem, int index) async {
    /* フッターを隠したいページは、bodyを切り替えずに直接pushする */
    if (tabItem == "NewPost") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PostScreen(),
        ),
      );
      return;
    } else if (tabItem == "Map") {
      Position posi = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String uid = FirebaseAuth.instance.currentUser!.uid;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckPlacesMap(
            latLng: LatLng(
              posi.latitude,
              posi.longitude,
            ),
            uid: uid,
            fromPost: false,
          ),
        ),
      );
      return;
    }

    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = _pageKeys[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final VoidCallback popUntilFirstScreen = () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    };

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentPage]!.currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "Home") {
            _selectTab("Home", 0);
            return false;
          } else {
            return false;
          }
        }

        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _pageKeys.indexOf(_currentPage),
          children: _pageKeys
              .map(
                (key) => TabNavigator(
                  popUntilFirstScreen: popUntilFirstScreen,
                  navigatorKey: _navigatorKeys[key]!,
                  tabItem: key,
                ),
              )
              .toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black45,
          selectedItemColor: Colors.black87,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: (index) {
            _selectTab(_pageKeys[index], index);
          },
          currentIndex: _pageKeys.indexOf(_currentPage),
          items: _pageKeys
              .map(
                (key) => BottomNavigationBarItem(
                  icon: Icon(_bottomNaviItems[key]),
                  label: "",
                  tooltip: "",
                ),
              )
              .toList(),
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
