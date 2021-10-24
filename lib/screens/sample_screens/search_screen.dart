import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dish/main.dart';
import 'package:dish/configs/constant_colors.dart';

class SearchScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "sample screen",
          style: TextStyle(color: AppColor.kPrimaryTextColor),
        ),
        backgroundColor: AppColor.kWhiteColor,
      ),
      body: SafeArea(
        child: Center(
          child: TextButton(
            child: Text("Search"),
            onPressed: () {
              // ログアウトの例
              watch(isLoginProvider).state = false;
            },
          ),
        ),
      ),
    );
  }
}
