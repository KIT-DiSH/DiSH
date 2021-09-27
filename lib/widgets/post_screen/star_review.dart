import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StarReview extends StatefulWidget {
  StarReview({
    Key? key,
    required this.sectionName,
    required this.rating,
    required this.emitRating,
  }) : super(key: key);
  final String sectionName;
  final double rating;
  final Function emitRating;

  @override
  _StarReviewState createState() => _StarReviewState();
}

class _StarReviewState extends State<StarReview> {
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
              initialRating: widget.rating,
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
                widget.emitRating(rating, widget.sectionName);
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
