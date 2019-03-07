import 'package:flipflop/models/word_view_model.dart';
import 'package:flutter/material.dart';

class StackCardWidget extends StatefulWidget {
  final WordViewModel card;

  StackCardWidget({
    Key key,
    this.card
  }) : super(key: key);

  @override
  _StackCardState createState() => _StackCardState();
}

class _StackCardState extends State<StackCardWidget> {
  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    return Container(
      child: RaisedButton(
        color: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        onPressed: () {},
        child: Text(
          card.word,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16.0
          ),
        )
      ),
    );
  }
}
