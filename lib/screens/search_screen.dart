import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish/configs/constant_colors.dart';

import 'package:dish/models/User.dart';
import 'package:dish/widgets/common/simple_divider.dart';
import 'package:dish/widgets/search_screen/user_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
    required this.openFooter,
    required this.closeFooter,
  }) : super(key: key);

  final VoidCallback openFooter;
  final VoidCallback closeFooter;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<User> _searchResult = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          // The search area here
          title: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search),
                    splashColor: AppColor.kWhiteColor,
                    highlightColor: AppColor.kWhiteColor,
                    onPressed: () async {
                      print("🔍searching user...");
                      final result = await _searchUser(_searchController.text);
                      setState(() {
                        _searchResult = result;
                      });
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    splashColor: AppColor.kWhiteColor,
                    highlightColor: AppColor.kWhiteColor,
                    onPressed: () {
                      _searchController.text = "";
                      setState(() {
                        _searchResult = [];
                      });
                    },
                  ),
                  hintText: 'ユーザーを検索',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          backgroundColor: AppColor.kWhiteColor,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: ListView.separated(
            itemBuilder: (context, index) {
              if (index == _searchResult.length)
                return SimpleDivider(height: 1.0);

              return UserCard(
                user: _searchResult[index],
                openFooter: widget.openFooter,
                closeFooter: widget.closeFooter,
              );
            },
            separatorBuilder: (_, __) => SimpleDivider(height: 1.0),
            itemCount: _searchResult.length + 1,
          ),
        ),
      ),
    );
  }

  Future<List<User>> _searchUser(String searchText) async {
    QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseFirestore
        .instance
        .collection("USERS")
        .where("user_id", isEqualTo: searchText)
        .get();

    return snapshots.docs.map((doc) {
      return User(
        uid: doc.id,
        userId: doc.data()["user_id"],
        userName: doc.data()["user_name"],
        profileText: doc.data()["profile_text"],
        iconImageUrl: doc.data()["icon_path"],
      );
    }).toList();
  }
}
