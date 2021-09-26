import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class TextFieldWithHint extends StatelessWidget {
  const TextFieldWithHint({
    Key? key,
    this.isPassword = false,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  final bool isPassword;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white.withOpacity(0.65),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColor.kPrimaryTextColor.withOpacity(0.6),
        ),
        contentPadding: EdgeInsets.all(14),
      ),
      style: TextStyle(fontSize: 14),
      controller: controller,
      obscureText: isPassword,
    );
  }
}
