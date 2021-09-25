import 'package:flutter/material.dart';

class SimpleAlertDialog extends StatelessWidget {
  const SimpleAlertDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final title;
  final content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text("キャンセル"),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Text("はい"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
