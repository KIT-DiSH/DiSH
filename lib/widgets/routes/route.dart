import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dish/screens/map_screen.dart';
import 'package:dish/screens/post_screen.dart';
import 'package:dish/screens/chek_places_map.dart';
import 'package:dish/widgets/routes/tab_navigator.dart';

final footerIndexProvider = StateProvider((ref) => 0);
final isOpenFooterProvider = StateProvider((ref) => true);

class RouteWidget extends ConsumerWidget {
  RouteWidget({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    int _currentPageIndex = watch(footerIndexProvider).state;
    bool _isOpenFooter = watch(isOpenFooterProvider).state;

    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: _pageKeys
            .map(
              (key) => TabNavigator(
                navigatorKey: _navigatorKeys[key]!,
                tabItem: key,
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: _isOpenFooter
          ? BottomNavigationBar(
              unselectedItemColor: Colors.black45,
              selectedItemColor: Colors.black87,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              onTap: (index) {
                if (index == 2) {
                  // watch(isOpenFooterProvider).state = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PostScreen()),
                  );
                } else if (index == 3) {
                  // watch(isOpenFooterProvider).state = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MapScreen()),
                  );
                } else {
                  context.read(footerIndexProvider).state = index;
                }
              },
              currentIndex: _currentPageIndex,
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
            )
          : null,
    );
  }
}
