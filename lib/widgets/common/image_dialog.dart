import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  const ImageDialog({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final imagePath;

  @override
  Widget build(BuildContext context) {
    final _mediaWidth = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: _mediaWidth,
        height: _mediaWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              imagePath,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
