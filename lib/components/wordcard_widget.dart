import 'dart:math';
import 'dart:ui';

import 'package:flip/models/model.dart';
import 'package:flutter/material.dart';

class CardFlipper extends StatefulWidget {
  final List<WordViewModel> cards;
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

  bool flipped = false;

  AnimationController finishScrollController;
  AnimationController flipController;

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

  void _onTap() {
    if(flipped) {
      flipController.reverse();
    } else {
      flipController.forward();
    }
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

    flipController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    )..addListener(() {
      setState(() {

      });
    })
    ..addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.forward
        || status == AnimationStatus.reverse) {
        setState(() {
          flipped = !flipped;
        });
      }
    });
  }

  @override
  void dispose() {
    finishScrollController.dispose();
    flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onTap: _onTap,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }

  List<Widget> _buildCards() {
    int index = -1;
    return widget.cards.map((WordViewModel wordViewModel) {
      index++;
      return _buildCard(wordViewModel, index);
    }).toList();
  }

  Widget _buildCard(WordViewModel wordViewModel, int cardIndex) {
    final numOfCards = widget.cards.length;
    final cardScrollPercent = scrollPercent / (1 / numOfCards);

    return FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Transform(
          transform: _buildCardProjection(),
          child: WordCardWidget(
            viewModel: wordViewModel
          ),
        ),
      ),
    );
  }

  Matrix4 _buildCardProjection() {
    final perspective = 0.002;
    final radius = 1.0;
    final angle = flipController.value * pi;
    final width = MediaQuery.of(context).size.width - 16.0 * 2;

    Matrix4 projection = Matrix4.identity()
    ..setEntry(0, 0, 1/radius)
    ..setEntry(1, 1, 1/radius)
    ..setEntry(3, 2, -perspective)
    ..setEntry(2, 3, -radius)
    ..setEntry(3, 3, perspective * radius + 1.0);

    projection *= Matrix4.translationValues(width/2, 0.0, 0.0)
        * Matrix4.rotationY(angle)
        * Matrix4.translationValues(0.0, 0.0, radius)
        * Matrix4.translationValues(-width/2, 0.0, 0.0)
        ;


    return projection;
  }
}

class WordCardWidget extends StatelessWidget {
  final WordViewModel viewModel;

  const WordCardWidget({
    Key key,
    @required this.viewModel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200.0,
        alignment: Alignment.center,
        child: Text(
          viewModel.word,
          style: TextStyle(
              fontSize: 25.0,
              letterSpacing: 2
          ),
        ),
      ),
    );
  }
}