import 'package:flutter/material.dart';
import 'dart:io';

import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:dish/configs/constant_colors.dart';

class ImageList extends StatefulWidget {
  ImageList({Key? key}) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<AssetEntity> selectedAssets = []; // AssetPickerの重複制御用
  List<File> selectedImageFiles = []; // 画像の表示用

  @override
  Widget build(BuildContext context) {
    final _mediaWidth = MediaQuery.of(context).size.width;
    final _itemCount = selectedAssets.length + 1;
    List<File> _tmpFiles = [];

    return SizedBox(
      height: 80,
      width: _mediaWidth,
      child: ListView.separated(
        itemCount: _itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
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
                      textDelegate: JapaneseTextDelegate(),
                      themeColor: AppColor.kPinkColor,
                      requestType: RequestType.image,
                    ).then(
                      (assets) async => {
                        if (assets != null)
                          {
                            await Future.forEach(
                              assets,
                              (AssetEntity asset) async {
                                _tmpFiles.add((await asset.file)!);
                              },
                            ),
                            setState(() {
                              selectedAssets = assets;
                              selectedImageFiles = _tmpFiles;
                            }),
                          },
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      child: Center(
                        child: Icon(Icons.add_photo_alternate, size: 42.0),
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
                    _cropImage(index - 1);

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
                    child: Image.file(
                      selectedImageFiles[index - 1],
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

  Future<Null> _cropImage(int index) async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: (await selectedAssets[index].file)!.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (croppedFile != null) {
      setState(() {
        selectedImageFiles[index] = croppedFile;
      });
    }
  }
}
