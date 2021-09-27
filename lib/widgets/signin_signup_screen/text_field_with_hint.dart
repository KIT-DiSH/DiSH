import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import 'package:dish/configs/constant_colors.dart';

class TextFieldWithHint extends StatefulWidget {
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
  _TextFieldWithHintState createState() => _TextFieldWithHintState();
}

class _TextFieldWithHintState extends State<TextFieldWithHint> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
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
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColor.kPrimaryTextColor.withOpacity(0.6),
            ),
            contentPadding: EdgeInsets.all(14),
            suffixIcon: widget.isPassword
                ? IconButton(
                    color: Colors.black26,
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "このフィールドに入力してください";
            } else if (!widget.isPassword && !EmailValidator.validate(value)) {
              return "有効なメールアドレスではありません";
            } else {
              return null;
            }
          },
          style: TextStyle(fontSize: 14),
          controller: widget.controller,
          obscureText: widget.isPassword ? _isObscure : false,
        ),
      ],
    );
  }
}
