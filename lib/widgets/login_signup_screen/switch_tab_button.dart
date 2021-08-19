import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class SwitchTabButton extends StatefulWidget {
  const SwitchTabButton({
    Key key,
    @required this.switchTab,
  }) : super(key: key);

  final ValueChanged<String> switchTab;

  @override
  _SwitchTabButtonState createState() => _SwitchTabButtonState();
}

class _SwitchTabButtonState extends State<SwitchTabButton> {
  double _loginAlign = -1;
  double _signInAlign = 1;
  double _xAlign = -1;
  final Color _selectedColor = Colors.white;
  final Color _normalColor = AppColor.kPinkColor;
  Color _loginColor = Colors.white;
  Color _signInColor = AppColor.kPinkColor;

  void _switchTab(selectedTab) {
    widget.switchTab(selectedTab);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 150;
    final int duration = 250;

    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0,
            spreadRadius: 1.2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(_xAlign, 0),
            duration: Duration(milliseconds: duration),
            curve: Curves.fastOutSlowIn,
            child: Container(
              width: width * 0.5,
              height: 35,
              decoration: BoxDecoration(
                color: AppColor.kPinkColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _switchTab("login");
              setState(() {
                _xAlign = _loginAlign;
                _loginColor = _selectedColor;
                _signInColor = _normalColor;
              });
            },
            child: Align(
              alignment: Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: AnimatedDefaultTextStyle(
                  style: TextStyle(color: _loginColor),
                  duration: Duration(milliseconds: duration),
                  child: Text(
                    'ログイン',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _switchTab("signup");
              setState(() {
                _xAlign = _signInAlign;
                _signInColor = _selectedColor;
                _loginColor = _normalColor;
              });
            },
            child: Align(
              alignment: Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: AnimatedDefaultTextStyle(
                  style: TextStyle(color: _signInColor),
                  duration: Duration(milliseconds: duration),
                  child: Text(
                    'サインアップ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
