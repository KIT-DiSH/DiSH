import 'package:dish/widgets/common/image_dialog.dart';
import 'package:flutter/material.dart';

class ImageList extends StatelessWidget {
  const ImageList({
    Key key,
    @required this.imagePath,
  }) : super(key: key);

  final imagePath;

  @override
  Widget build(BuildContext context) {
    final _mediaWidth = MediaQuery.of(context).size.width;
    final _outerPadding = 16;

    return SizedBox(
      height: 80,
      width: _mediaWidth - _outerPadding * 2,
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          int imageIndex = index % 3 + 1; // dummy用なので削除

          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ImageDialog(
                    imagePath: "assets/images/sample$imageIndex.png",
                  );
                },
              );
            },
            child: Image(
              image: AssetImage(
                "assets/images/sample$imageIndex.png",
              ),
              height: 80,
              width: 80,
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
