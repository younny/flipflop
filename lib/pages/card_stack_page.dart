import 'package:flipflop/components/stackcard_widget.dart';
import 'package:flipflop/fixtures/mock_data.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flutter/material.dart';

class CardStackPage extends StatefulWidget {
  @override
  _CardStackPageState createState() => _CardStackPageState();
}

class _CardStackPageState extends State<CardStackPage> {
  bool isCardSelectMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.playlist_play),
            iconSize: 32,
            onPressed: () {
              _goToGamePage();
            },
          )
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "My Stack",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 22
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),

                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: GridView.count(
                    primary: false,
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2,
                    children: _buildWordCardWidgets(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<StackCardWidget> _buildWordCardWidgets() {
    return mockCards.map((card) {
      return StackCardWidget(
        card: card,
        onPress: (card) => _onCardPress(card),
        onLongPress: (card) => _onCardLongPress(card),
        selectMode: isCardSelectMode,
      );
    }).toList();
  }

  void _onCardPress(WordViewModel card) {
    print("Stack card onPress: ${card.word}");

  }

  void _onCardLongPress(WordViewModel card) {
    print("Stack card onLongPress: ${card.word}");

    setState(() {
      isCardSelectMode = true;
    });
  }

  void _goToGamePage() {
    Navigator.pushNamed(context, "/game");
  }
}
