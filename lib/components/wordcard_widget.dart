import 'dart:ui';

import 'package:flip/models/model.dart';
import 'package:flutter/material.dart';

class WordCardWidget extends StatelessWidget {
  static const double OUTER_PADDING = 16.0;
  static const double INNER_PADDING = 16.0;

  final WordViewModel viewModel;
  final bool flipped;

  const WordCardWidget({
    Key key,
    @required this.viewModel,
    this.flipped = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox.fromSize(
        size: Size(screenWidth, 220),
        child: Padding(
          padding: const EdgeInsets.all(INNER_PADDING),
          child: Card(
            color: Colors.amber,
            elevation: 5,
            child: _buildCardView(screenWidth - (INNER_PADDING * 2)),
          ),
        ),
      ),
    );
  }

  Widget _buildCardView(double cardWidth) {
    if(flipped) {
      return _buildBackView();
    } else {
      return _buildFrontView();
    }
  }

  Widget _buildFrontView() {
    return Center(
      child: Text(
        viewModel.word,
        style: TextStyle(
            fontSize: 25.0,
            letterSpacing: 2
        ),
      ),
    );
  }

  Widget _buildBackView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              viewModel.word,
              style: TextStyle(
                fontSize: 24.0,
                letterSpacing: 2
              )
            ),
          ),
          Text(
            ' ${viewModel.meaning}',
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 8,
            style: TextStyle(
                fontSize: 14.0,
                letterSpacing: 2
            ),
          )
        ],
      ),
    );
  }
}
