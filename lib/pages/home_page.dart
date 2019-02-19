import 'package:flip/components/bottom_bar.dart';
import 'package:flip/components/card_list.dart';
import 'package:flip/models/model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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


