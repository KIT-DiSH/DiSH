import 'package:flutter/material.dart';

class ItemModel {
  bool expanded;
  String headerItem;
  String discription;
  Color colorsItem;

  ItemModel({
    this.expanded: false,
    this.headerItem,
    this.discription,
    this.colorsItem,
  });
}

class ExpansionPanelDemo extends StatefulWidget {
  @override
  _ExpansionPanelDemoState createState() => _ExpansionPanelDemoState();
}

class _ExpansionPanelDemoState extends State<ExpansionPanelDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionPanelList(
        animationDuration: Duration(
          milliseconds: 500,
        ),
        elevation: 1,
        expandedHeaderPadding: EdgeInsets.all(8),
        children: [
          ExpansionPanel(
            body: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    itemData.discription,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                        letterSpacing: 0.3,
                        height: 1.3),
                  ),
                ],
              ),
            ),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  itemData.headerItem,
                  style: TextStyle(
                    color: itemData.colorsItem,
                    fontSize: 12,
                  ),
                ),
              );
            },
            isExpanded: itemData.expanded,
          ),
        ],
        expansionCallback: (int item, bool status) {
          setState(
            () {
              itemData.expanded = !itemData.expanded;
            },
          );
        },
      ),
    );
  }

  ItemModel itemData = ItemModel(
    headerItem: 'コメント',
    discription: "ここにコメントの要素をいれる",
    colorsItem: Colors.grey,
  );
}
