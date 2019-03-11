import 'dart:async';

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
  List<WordViewModel> myCards;
  Set<WordViewModel> selectedCards;

  @override
  void initState() {
    super.initState();

    myCards = mockCards;
    selectedCards = Set.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: _buildAppBarIconsByState(isCardSelectMode),
      ),
      backgroundColor: isCardSelectMode ? Colors.blueGrey.shade700 : Colors.blueGrey,
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
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: GridView.count(
                      primary: false,
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 2,
                      children: _buildWordCardWidgets(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAppBarIconsByState(bool isCardSelectMode) {
    if(isCardSelectMode) {
      return _buildDeleteModeIconSet();
    }

    return _buildDefaultIconSet();
  }

  List<Widget> _buildDeleteModeIconSet() {
    return [
      IconButton(
        icon: Icon(Icons.delete),
        iconSize: 27,
        color: Colors.amberAccent,
        onPressed: () => _deleteSelectedCards()
      ),
      IconButton(
        icon: Icon(Icons.check),
        iconSize: 27,
        color: Colors.amberAccent,
        onPressed: () => _closeSelectionMode(),
      )
    ];
  }

  List<Widget> _buildDefaultIconSet() {
    return [
      IconButton(
        icon: Icon(Icons.playlist_play),
        iconSize: 32,
        onPressed: () {
          _goToGamePage();
        },
      )
    ];
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
    if(isCardSelectMode) {
      _checkAndUpdateSelectedCards(card);
    }
  }

  void _checkAndUpdateSelectedCards(WordViewModel card) {
    setState(() {
      if(selectedCards.contains(card)) {
        selectedCards.remove(card);
      } else {
        selectedCards.add(card);
      }
    });
  }

  void _onCardLongPress(WordViewModel card) {
    setState(() {
      isCardSelectMode = true;
      selectedCards.add(card);
    });
  }

  void _goToGamePage() {
    Navigator.pushNamed(context, "/game");
  }

  void _closeSelectionMode() {
    setState(() {
      isCardSelectMode = false;
    });
  }

  void _deleteSelectedCards() {
    setState(() {
      selectedCards.forEach((card) {
        myCards.remove(card);
      });
    });

    _emptySelectedCards();

    _closeSelectionMode();
  }

  void _emptySelectedCards() {
    setState(() {
      selectedCards = Set.identity();
    });
  }

  Future<void> _onRefresh() {
    // TODO This is fake timer. Needs to be real data from local storage.
    Completer<void> completer = Completer<void>();
    Timer(Duration(seconds: 1), () {
      completer.complete();
    });

    return completer.future;
  }
}
