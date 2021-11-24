import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dish/widgets/timeline_screen/insta_body.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  String? _userIconPath;

  @override
  Future<void> didChangeDependencies() async {
    // Firebaseが持つ値を使う
    String uid = "uruCi5pw8gWNOQeudRWfYiQ8Age2";
    super.didChangeDependencies();
    await _getUserIconPath(uid);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(_userIconPath),
      body: InstaBody(),
    );
  }

  Future<void> _getUserIconPath(String uid) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection("USERS").doc(uid);
    DocumentSnapshot snapshot = await userRef.get();

    if (!snapshot.exists) {
      print("Something went wrong");
      return;
    }

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      _userIconPath = data["icon_path"];
    });
  }

  AppBar _buildAppBar(String? iconPath) {
    return AppBar(
      backgroundColor: const Color(0xFFF8FAF8),
      centerTitle: false,
      elevation: 1.0,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 30.0,
          child: Image.asset('assets/images/dish-logo.png'),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: new Container(
            height: 40,
            width: 40,
            decoration: new BoxDecoration(
              border: Border.all(color: Colors.black),
              shape: BoxShape.circle,
              image: iconPath != null
                  ? new DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: new NetworkImage(iconPath),
                    )
                  : null,
            ),
          ),
        )
      ],
    );
  }
}
