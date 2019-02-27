import 'dart:ui';

import 'package:flip/models/word_view_model.dart';
import 'package:flip/utils/string_formatter.dart';
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
        size: Size(screenWidth, screenWidth * 0.65),
        child: Padding(
          padding: const EdgeInsets.all(INNER_PADDING),
          child: Card(
            color: Colors.amber,
            elevation: 5,
            child: _buildCardView(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardView() {
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
            fontWeight: FontWeight.bold,
            letterSpacing: 2
        ),
      ),
    );
  }

  Widget _buildBackView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  viewModel.word,
                  style: TextStyle(
                    fontSize: 24.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold
                  )
                ),
                Text(
                  '[${viewModel.pronunciation}]',
                  style: TextStyle(
                    fontSize: 24.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal
                  )
                )
              ],
            ),
          ),
          Text(
            StringFormatter.formatMeaning(viewModel.meaning),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}
