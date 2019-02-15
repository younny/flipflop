import 'dart:math';
import 'dart:ui';

import 'package:flip/models/model.dart';
import 'package:flutter/material.dart';

class CardFlipper extends StatefulWidget {
  final List<WordViewModel> cards;
  final Function(double scrollPercent) onScroll;

  const CardFlipper({
    Key key,
    this.cards,
    this.onScroll
  }) : super(key: key);

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
  bool flipping = false;

  AnimationController finishScrollController;
  AnimationController flipController;

  void _onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;

    if(flipped) {
      flipController.reverse();
    }
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
      duration: Duration(milliseconds: 300)
    )..addListener(() {
      setState(() {
        flipping = true;
      });
    })
    ..addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.completed
        || status == AnimationStatus.dismissed) {
        setState(() {
          flipped = !flipped;
          flipping = false;
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
            viewModel: wordViewModel,
            flipping: flipping,
            flipped: flipped
          ),
        ),
      ),
    );
  }

  Matrix4 _buildCardProjection() {
    final perspective = 0.001;
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
  static const double OUTER_PADDING = 16.0;
  static const double INNER_PADDING = 16.0;

  final WordViewModel viewModel;
  final bool flipped;
  final bool flipping;

  const WordCardWidget({
    Key key,
    @required this.viewModel,
    this.flipped = false,
    this.flipping = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      color: Colors.amber,
      elevation: 5,
      child: Container(
        width: screenWidth,
        height: 200.0,
        padding: const EdgeInsets.all(INNER_PADDING),
        child: _buildCardView(screenWidth - (OUTER_PADDING * 2 + INNER_PADDING * 2)),
      ),
    );
  }

  Widget _buildCardView(double cardWidth) {

    if(flipping) {
      return Container();
    }

    if(flipped) {
      return Transform(
        transform: Matrix4.rotationY(pi) * Matrix4.translationValues(-cardWidth + 5, 0.0, 0.0),
        child: _buildBackView()
      );
    }

    return _buildFrontView();
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
    return Column(
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
              fontSize: 15.0,
              letterSpacing: 2
          ),
        )
      ],
    );
  }
}