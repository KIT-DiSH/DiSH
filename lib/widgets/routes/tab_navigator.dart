import 'package:flutter/material.dart';

import 'package:dish/screens/post_screen.dart';
import 'package:dish/screens/profile_screen.dart';
import 'package:dish/screens/timeline_screen.dart';
import 'package:dish/screens/sample_screens/map_screen.dart';
import 'package:dish/screens/sample_screens/search_screen.dart';

class TabNavigator extends StatelessWidget {
  TabNavigator({
    required this.navigatorKey,
    required this.tabItem,
  });
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (tabItem) {
      case "Home":
        child = Timeline();
        break;
      case "Search":
        child = SearchScreen();
        break;
      case "NewPost":
        child = PostScreen();
        break;
      case "Map":
        child = MapScreen();
        break;
      case "Profile":
        child = ProfileScreen();
        break;
      default:
        child = Container();
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (_) => child);
      },
    );
  }
}
