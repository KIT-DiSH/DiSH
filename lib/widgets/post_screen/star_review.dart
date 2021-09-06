import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StarReview extends StatefulWidget {
  StarReview({
    Key? key,
    @required this.sectionName,
  }) : super(key: key);
  final sectionName;

  @override
  _StarReviewState createState() => _StarReviewState();
}

class _StarReviewState extends State<StarReview> {
  late double _rating;
  double _initialRating = 2.0;

  @override
  Widget build(BuildContext context) {
    final _mediaWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: _mediaWidth - 32,
      height: 30,
      child: Stack(
        children: <Widget>[
          Text(
            widget.sectionName,
            style: Theme.of(context).textTheme.headline6,
          ),
          Positioned(
            child: RatingBar.builder(
              initialRating: _initialRating,
              minRating: 1,
              unratedColor: Colors.amber.withAlpha(50),
              itemCount: 5,
              itemSize: 30.0,
              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
              glowColor: Colors.amber.withAlpha(50),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  this._rating = rating;
                });
              },
              updateOnDrag: true,
            ),
            left: 100,
          ),
        ],
      ),
    );
  }
}
