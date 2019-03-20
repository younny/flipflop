import 'package:flipflop/models/db_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/pages/settings_page.dart';
import 'package:flipflop/repo/local_db.dart';
import 'package:flipflop/widgets/bottom_bar.dart';
import 'package:flipflop/widgets/card_list.dart';
import 'package:flipflop/widgets/dropdown_dialog.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final Stream<List<WordViewModel>> cards;
  final List<WordViewModel> stackCards;

  GamePage({
    this.cards,
    this.stackCards
  });

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double scrollPercent = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: isFromMyStackCards()
            ? _buildMyStackCardsView()
            : _buildRemoteCardsView(),
      )
    );
  }

  bool isFromMyStackCards() => widget.stackCards != null;

  Widget _buildMyStackCardsView() {
    final length = widget.stackCards.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: CardListWidget(
              cards: widget.stackCards,
              onScroll: (double scrollPercent) {
                setState(() {
                  this.scrollPercent = scrollPercent;
                });
              }
          ),
        ),
        BottomBar(
            numOfSteps: length,
            scrollPercent: scrollPercent,
            onLeftIconPress: () => _navigateToSettingsPage()
        ),
      ],
    );
  }

  Widget _buildRemoteCardsView() {
    return StreamBuilder(
      stream: widget.cards,
      builder: (BuildContext context, AsyncSnapshot<List<WordViewModel>> snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoadingView();
          default:
            return _buildGameView(snapshot);
        }
      },
    );
  }

  Widget _buildLoadingView() {
    return Center(
        child: CircularProgressIndicator()
    );
  }

  Widget _buildGameView(AsyncSnapshot<List<WordViewModel>> snapshot) {
    final length = snapshot.data.length;
    final index = (scrollPercent * length).round();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: CardListWidget(
              cards: snapshot.data,
              onScroll: (double scrollPercent) {
                setState(() {
                  this.scrollPercent = scrollPercent;
                });
              }
          ),
        ),
        BottomBar(
            numOfSteps: length,
            scrollPercent: scrollPercent,
            onLeftIconPress: () => _navigateToSettingsPage(),
            onRightIconPress: () {
              //_showAddToMyStackAlert(snapshot.data[index])
              onSave(snapshot.data[index], dbName);

              _showSnackBar();
            }
        )
      ],
    );
  }

  void _navigateToSettingsPage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage())
    );
  }

  void onSave(WordViewModel word, String fileName) {
    _openAndInsertDatabase(word, fileName);
  }

  void _openAndInsertDatabase(WordViewModel word, String fileName) async {
    LocalDB db = LocalDB.instance;
    await db.open();

    await _insertData(word);

    await db.close();
  }

  Future _insertData(WordViewModel item) async {
    LocalDB db = LocalDB.instance;
    int id = await db.insert(item);

    print('item $id is inserted.');
  }

  void _showSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Add to my stack!"),
        duration: Duration(seconds: 3)
      )
    );
  }

  Future<String> _showAddToMyStackAlert(WordViewModel word) {
    List<String> folders = [];
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DropdownDialog(
              title: "Add to my stack",
              items: folders,
              onDone: (path) {
                onSave(word, path);

                Navigator.pop(context);
              },
              onChange: (index) {}
          );
        }
    );
  }
}


