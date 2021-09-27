import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class DividerWithLabel extends StatelessWidget {
  const DividerWithLabel({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.black12,
            thickness: 2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            label,
            style: TextStyle(
              color: AppColor.kPrimaryTextColor.withOpacity(0.65),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.black12,
            thickness: 2,
          ),
        ),
      ],
    );
  }
}
