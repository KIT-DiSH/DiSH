import 'package:flutter/material.dart';

import 'package:dish/configs/constant_colors.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleText = "新規投稿";
    final _hintText = "投稿文を書く";
    final _restaurantName = "";
    final _mediaWidth = MediaQuery.of(context).size.width;
    final _outerPadding = 16.0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios),
          title: Text(_titleText),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                color: AppColor.kPinkColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      child: Text(
                        _restaurantName != "" ? _restaurantName : "店名",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Container(
                      height: 200,
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyText2,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: _hintText,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
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
                                  return Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    child: Container(
                                      width: _mediaWidth,
                                      height: _mediaWidth,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/images/sample$imageIndex.png",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
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
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black.withOpacity(0.32),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "タグ",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          width: _mediaWidth - 100,
                          child: ListView.separated(
                            itemCount: 10,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (BuildContext context, int index) {
                              return Align(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Chip(
                                    label: Text("aaa"),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    backgroundColor: Colors.white,
                                    elevation: 2,
                                  ),
                                ),
                                alignment: Alignment.topLeft,
                              );
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black.withOpacity(0.32),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "場所",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          width: _mediaWidth - 100,
                          child: ListView.separated(
                            itemCount: 10,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (BuildContext context, int index) {
                              return Align(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Chip(
                                    label: Text("aaa"),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    backgroundColor: Colors.white,
                                    elevation: 2,
                                  ),
                                ),
                                alignment: Alignment.topLeft,
                              );
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black.withOpacity(0.32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
