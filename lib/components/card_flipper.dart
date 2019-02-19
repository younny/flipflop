import 'dart:math';

import 'package:flutter/material.dart';

class CardFlipper extends StatefulWidget {
  final Widget front;
  final Widget back;

  CardFlipper({
    this.front,
    this.back
  });

  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> with SingleTickerProviderStateMixin {
  bool reversed = false;
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
    );

    _animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(
              begin: 0.0,
              end: -pi/2
          ),
          weight: 0.5
      ),
      TweenSequenceItem(
          tween: Tween(
              begin: pi/2,
              end: 0.0
          ),
          weight: 0.5
      )
    ]).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return Transform(
          alignment: Alignment.center,
          transform: _buildCardProjection(),
          child: GestureDetector(
            onTap: _toggleFlip,
            child: IndexedStack(
              children: <Widget>[
                widget.front,
                widget.back
              ],
              alignment: Alignment.center,
              index: _animationController.value < 0.5 ? 0 : 1,
            ),
          ),
        );
      },
    );
  }

  void _toggleFlip() {
    if(!mounted)
      return;

    if(reversed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    reversed = !reversed;
  }

  Matrix4 _buildCardProjection() {
    final perspective = 0.001;

    Matrix4 projection = Matrix4.identity()
      ..setEntry(3, 2, perspective)
      ..rotateY(_animation.value);

    return projection;
  }
}