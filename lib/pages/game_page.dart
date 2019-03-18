import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/models/db_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/pages/settings_page.dart';
import 'package:flipflop/providers/base_provider.dart';
import 'package:flipflop/widgets/bottom_bar.dart';
import 'package:flipflop/widgets/card_list.dart';
import 'package:flipflop/widgets/dropdown_dialog.dart';
import 'package:flipflop/repo/local_db.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final FlipFlopBloc bloc;

  GamePage({
    this.bloc
  });

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double scrollPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FlipFlopBloc>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: StreamBuilder(
        stream: bloc.cards,
        builder: (BuildContext context, AsyncSnapshot<List<WordViewModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

            final length = snapshot.data.length;
            final index = (scrollPercent * length).round();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: 20.0
                ),
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

                    _showSnackBar(context);
                  }
                ),
                Container(
                    width: double.infinity,
                    height: 20.0
                )
              ],
            );
        },
      ),
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

  void _showSnackBar(BuildContext context) {
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


