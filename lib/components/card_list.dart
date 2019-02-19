import 'dart:ui';

import 'package:flip/components/card_flipper.dart';
import 'package:flip/components/wordcard_widget.dart';
import 'package:flip/models/model.dart';
import 'package:flutter/material.dart';

class CardListWidget extends StatefulWidget {
  final List<WordViewModel> cards;
  final Function(double scrollPercent) onScroll;

  const CardListWidget({
    Key key,
    this.cards,
    this.onScroll
  }) : super(key: key);

  @override
  _CardListWidgetState createState() => _CardListWidgetState();
}

class _CardListWidgetState extends State<CardListWidget> with TickerProviderStateMixin {
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;

  AnimationController finishScrollController;
  ScrollController scrollController;

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

      final cardScrollPercent = scrollPercent * numOfCards;
      scrollController.jumpTo(360 * cardScrollPercent);

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

    scrollController = ScrollController();

    finishScrollController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 150)
    )
      ..addListener(() {
        setState(() {
          scrollPercent = lerpDouble(finishScrollStart, finishScrollEnd, finishScrollController.value);
          final cardScrollPercent = scrollPercent * mockCards.length;
          final cardWidth = MediaQuery.of(context).size.width;
          scrollController.animateTo(cardWidth * cardScrollPercent, duration: Duration(milliseconds: 150), curve: Curves.easeOut);

          if(widget.onScroll != null) {
            widget.onScroll(scrollPercent);
          }
        });
      });

  }

  @override
  void dispose() {
    finishScrollController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: ListView.builder(
        controller: scrollController,
        itemExtent: MediaQuery.of(context).size.width,
        itemCount: mockCards.length,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return _buildCard(mockCards[index], index);
        },
      ),
    );
  }

  Widget _buildCard(WordViewModel wordViewModel, int cardIndex) {
    return CardFlipper(
        front: WordCardWidget(
          viewModel: wordViewModel,
          flipped: false,
        ),
        back : WordCardWidget(
          viewModel: wordViewModel,
          flipped: true,
        )
    );
  }
}