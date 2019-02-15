import 'package:flip/components/wordcard_widget.dart';
import 'package:flip/models/model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 20.0
        ),
        
        Expanded(
          child: Center(
            child: CardFlipper(
              cards: mockCards
            ),
          ),
        ),

        BottomBar(
          numOfSteps: mockCards.length,
          scrollPercent: 0.0
        ),

        Container(
            width: double.infinity,
            height: 20.0
        )
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  final int numOfSteps;
  final double scrollPercent;

  const BottomBar({
    this.numOfSteps,
    this.scrollPercent
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Center(
                child: Icon(
                  Icons.settings
                ),
              ),
            ),
            Container(

            ),
            Container(
              child: Center(
                child: Icon(
                  Icons.add
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}