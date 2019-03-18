import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/providers/base_provider.dart';
import 'package:flipflop/widgets/bottom_bar.dart';
import 'package:flipflop/widgets/card_list.dart';
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
                    scrollPercent: scrollPercent
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
}


