import 'package:flutter/material.dart';

class SimpleDivider extends StatelessWidget {
  const SimpleDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1,
      color: Colors.black.withOpacity(0.32),
    );
  }
}
