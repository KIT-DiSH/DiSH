import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black.withOpacity(0.45),
      iconSize: 26,
      elevation: 12.0,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: "search",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined),
          label: "post",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on_outlined),
          label: "map",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          label: "profile",
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
