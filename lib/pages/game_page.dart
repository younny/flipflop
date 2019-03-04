import 'package:flipflop/components/bottom_bar.dart';
import 'package:flipflop/components/card_list.dart';
import 'package:flipflop/fixtures/mock_data.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double scrollPercent = 0.0;

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
          child: CardListWidget(
            cards: mockCards,
            onScroll: (double scrollPercent) {
              setState(() {
                this.scrollPercent = scrollPercent;
              });
            }
          ),
        ),

        BottomBar(
          numOfSteps: mockCards.length,
          scrollPercent: scrollPercent
        ),

        Container(
            width: double.infinity,
            height: 20.0
        )
      ],
    );
  }
}


