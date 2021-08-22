import 'package:dish/widgets/common/image_dialog.dart';
import 'package:flutter/material.dart';

class ImageList extends StatelessWidget {
  const ImageList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mediaWidth = MediaQuery.of(context).size.width;
    final _itemCount = 6; // のちにimages.length

    return SizedBox(
      height: 80,
      width: _mediaWidth,
      child: ListView.separated(
        itemCount: _itemCount,
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
            child: Row(
              children: [
                if (index == 0) SizedBox(width: 16),
                Image(
                  image: AssetImage(
                    "assets/images/sample$imageIndex.png",
                  ),
                  height: 80,
                  width: 80,
                ),
                if (index == _itemCount - 1) SizedBox(width: 16),
              ],
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
