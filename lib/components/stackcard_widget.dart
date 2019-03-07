import 'package:flipflop/models/word_view_model.dart';
import 'package:flutter/material.dart';

typedef OnStackCardCallback = void Function(WordViewModel wordViewModel);

class StackCardWidget extends StatefulWidget {
  final WordViewModel card;
  final OnStackCardCallback onPress;
  final OnStackCardCallback onLongPress;

  StackCardWidget({
    Key key,
    @required this.card,
    this.onPress,
    this.onLongPress
  }): super(key: key);

  @override
  _StackCardState createState() => _StackCardState();
}

class _StackCardState extends State<StackCardWidget> {

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        child: RaisedButton(
          color: selected ? Colors.amber.withOpacity(0.5) : Colors.amber,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: onPressed,
          child: Text(
            card.word,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.0
            ),
          )
        ),
      ),
    );
  }

  void onLongPress() {
    setState(() {
      selected = !selected;
    });

    try {
      widget.onLongPress(widget.card);
    } catch (e) {
      print(e.toString());
    }
  }

  void onPressed() {
    try {
      widget.onPress(widget.card);
    } catch (e) {
      print(e.toString());
    }
  }
}
