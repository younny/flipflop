import 'dart:ui';

import 'package:flip/models/model.dart';
import 'package:flutter/material.dart';

class CardFlipper extends StatefulWidget {
  final List<WordCard> cards;
  final Function(double scrollPercent) onScroll;

  const CardFlipper({
    this.cards,
    this.onScroll
  });

  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> with TickerProviderStateMixin {
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;

  AnimationController finishScrollController;

  void _onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;

    final numOfCards = widget.cards.length;

    setState(() {
      scrollPercent = (startDragPercentScroll +
                          (-singleCardDragPercent / numOfCards))
                          .clamp(0.0, 1.0 - (1/numOfCards));

      if(widget.onScroll != null) {
        widget.onScroll(scrollPercent);
      }
    });

  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final numberOfCards = widget.cards.length;

    finishScrollStart = scrollPercent;
    finishScrollEnd = (scrollPercent * numberOfCards).round() / numberOfCards;
    finishScrollController.forward(from: 0.0);

    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }

  @override
  void initState() {
    super.initState();

    finishScrollController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150)
    )
    ..addListener(() {
      setState(() {
        scrollPercent = lerpDouble(finishScrollStart, finishScrollEnd, finishScrollController.value);

        if(widget.onScroll != null) {
          widget.onScroll(scrollPercent);
        }
      });
    });

  }

  @override
  void dispose() {
    finishScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }

  List<Widget> _buildCards() {
    int index = -1;
    return widget.cards.map((WordCard wordCard) {
      index++;
      return _buildCard(wordCard, index);
    }).toList();
  }

  Widget _buildCard(WordCard wordCard, int cardIndex) {
    final numOfCards = widget.cards.length;
    final cardScrollPercent = scrollPercent / (1 / numOfCards);

    return FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: WordCardWidget(
          word: wordCard.word
        ),
      ),
    );
  }
}

class WordCardWidget extends StatelessWidget {
  final String word;

  const WordCardWidget({
    Key key,
    @required this.word
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber,
      child: Container(
        width: double.infinity,
        height: 200.0,
        alignment: Alignment.center,
        child: Text(
          word,
          style: TextStyle(
              fontSize: 25.0,
              letterSpacing: 2
          ),
        ),
      ),
    );
  }
}