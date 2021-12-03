import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish/configs/constant_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
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
                      print(result);
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    splashColor: AppColor.kWhiteColor,
                    highlightColor: AppColor.kWhiteColor,
                    onPressed: () {
                      _searchController.text = "";
                    },
                  ),
                  hintText: 'ユーザーを検索',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          backgroundColor: AppColor.kWhiteColor,
        ),
      ),
    );
  }

  Future<List<String>> _searchUser(String searchText) async {
    QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseFirestore
        .instance
        .collection("USERS")
        .where("user_name", isEqualTo: searchText)
        .get();

    return snapshots.docs.map((doc) {
      // 将来的にはユーザーの情報を返す感じになる
      return doc.data()["user_name"] as String;
    }).toList();
  }
}
