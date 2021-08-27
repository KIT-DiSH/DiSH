import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class SimpleDivider extends StatelessWidget {
  const SimpleDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1,
      color: AppColor.kDefaultBorderColor.withOpacity(0.75),
    );
  }
}
