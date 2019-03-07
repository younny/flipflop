import 'package:flutter/material.dart';

class CardStackPage extends StatefulWidget {
  @override
  _CardStackPageState createState() => _CardStackPageState();
}

class _CardStackPageState extends State<CardStackPage> {
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Colors.amber,
                    style: BorderStyle.solid
                  )
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Container(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _goToGamePage() {
    Navigator.pushNamed(context, "/game");
  }
}
