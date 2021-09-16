import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class SimpleDivider extends StatelessWidget {
  final height;
  const SimpleDivider({Key? key, double this.height = 16}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: 1,
      color: AppColor.kDefaultBorderColor.withOpacity(0.75),
    );
  }
}
