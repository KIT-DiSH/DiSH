import 'dart:io';

import 'package:dish/configs/constant_colors.dart';
import 'package:dish/widgets/common/image_dialog.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageList extends StatefulWidget {
  ImageList({Key key}) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<AssetEntity> selectedAssets = [];

  @override
  Widget build(BuildContext context) {
    final _mediaWidth = MediaQuery.of(context).size.width;
    final _itemCount = selectedAssets.length + 1; // のちにimages.length

    return SizedBox(
      height: 80,
      width: _mediaWidth,
      child: ListView.separated(
        itemCount: _itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          int imageIndex = index % 3 + 1; // dummy用なので削除

          return Row(
            children: [
              if (index == 0) ...[
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    AssetPicker.pickAssets(
                      context,
                      maxAssets: 4,
                      selectedAssets: selectedAssets,
                      // requestType: RequestType.image,
                      textDelegate: JapaneseTextDelegate(),
                      themeColor: AppColor.kPinkColor,
                      requestType: RequestType.image,
                      specialItemPosition: SpecialItemPosition.prepend,
                      specialItemBuilder: (BuildContext context) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            final AssetEntity result =
                                await CameraPicker.pickFromCamera(
                              context,
                              enableRecording: false,
                              textDelegate: EnglishCameraPickerTextDelegate(),
                            );
                            if (result != null) {
                              // setState(() {
                              //   selectedAssets = [...selectedAssets, result];
                              //   print(selectedAssets);
                              // });
                              (BuildContext context, AssetEntity result) =>
                                  Navigator.of(context).pop(
                                    <AssetEntity>[...selectedAssets, result],
                                  );
                            }
                          },
                          child: const Center(
                            child: Icon(Icons.camera_enhance, size: 42.0),
                          ),
                        );
                      },
                    ).then(
                      (value) => {
                        if (value != null)
                          setState(() {
                            selectedAssets = value;
                            print(selectedAssets);
                          })
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      child: Center(
                        child: Icon(Icons.camera_enhance, size: 42.0),
                      ),
                      color: AppColor.kDefaultBorderColor,
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
              if (index != 0)
                GestureDetector(
                  onTap: () {
                    selectedAssets[index - 1]
                        .file
                        .then((file) => _cropImage(file.path));

                    // _cropImage(index - 1);
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return ImageDialog(
                    //       imagePath: "assets/images/sample$imageIndex.png",
                    //     );
                    //   },
                    // );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                      image: AssetEntityImageProvider(
                        selectedAssets[index - 1],
                        isOriginal: false,
                      ),
                      height: 80,
                      width: 80,
                    ),
                  ),
                ),
              if (index == _itemCount - 1) SizedBox(width: 16),
            ],
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Future<Null> _cropImage(String path) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
    );
    if (croppedFile != null) {
      // setState(() {
      //   selectedAssets[0].file.then();
      // });
      print(path);
      print(croppedFile.path);
    }
  }
}
