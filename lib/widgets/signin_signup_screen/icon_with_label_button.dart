import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class IconWithLabelButton extends StatelessWidget {
  const IconWithLabelButton({
    Key? key,
    required this.icon,
    required this.buttonText,
    required this.press,
    this.borderColor = AppColor.kDefaultBorderColor,
    this.textColor = const Color(0xFF6F6F6F),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  final Widget icon;
  final String buttonText;
  final VoidCallback press;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: 3.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: icon,
            ),
            Text(
              buttonText,
              style: TextStyle(color: textColor),
            ),
            SizedBox(
              width: 28,
              height: 28,
            ),
          ],
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
