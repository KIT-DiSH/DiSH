import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class InputForm extends StatefulWidget {
  InputForm({
    Key? key,
    required this.selectedTab,
    required this.setEmail,
    required this.setPassword,
    required this.setConfirmPassword,
  }) : super(key: key);

  final String selectedTab;
  final ValueChanged<String> setEmail;
  final ValueChanged<String> setPassword;
  final ValueChanged<String> setConfirmPassword;

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _hintMailText = "メールアドレス";
  final _hintPasswordText = "パスワード";
  final _hintComfirmPasswordText = "パスワード（再入力）";
  final _forgotPasswordText = "パスワードをお忘れの方";

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    final VoidCallback onEditingComplete = () => node.nextFocus();

    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Column(
            children: [
              buildTextField(
                false,
                _hintMailText,
                widget.setEmail,
                onEditingComplete,
                false,
              ),
              SizedBox(
                height: 16,
                width: double.infinity,
              ),
              buildTextField(
                true,
                _hintPasswordText,
                widget.setEmail,
                onEditingComplete,
                widget.selectedTab == "login",
              ),
              widget.selectedTab == "login"
                  ? Container(
                      height: 47,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          _forgotPasswordText,
                          style: TextStyle(
                            color: AppColor.kPrimaryTextColor.withOpacity(0.6),
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 16,
                          width: double.infinity,
                        ),
                        buildTextField(
                          true,
                          _hintComfirmPasswordText,
                          widget.setConfirmPassword,
                          onEditingComplete,
                          true,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Container buildTextField(
    obscureText,
    hintText,
    onChanged,
    onEditingComplete,
    isLastElem,
  ) {
    return Container(
      height: 31,
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.kDefaultBorderColor,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
          hintStyle: TextStyle(
            fontSize: 12,
            color: AppColor.kPrimaryTextColor.withOpacity(0.4),
          ),
        ),
        textInputAction:
            isLastElem ? TextInputAction.done : TextInputAction.next,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
