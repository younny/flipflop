import 'package:flipflop/models/word_view_model.dart';
import 'package:flutter/material.dart';

typedef OnStackCardCallback = void Function(WordViewModel wordViewModel);

class StackCardWidget extends StatefulWidget {
  final WordViewModel card;
  final OnStackCardCallback onPress;
  final OnStackCardCallback onLongPress;
  final bool selectMode;

  StackCardWidget({
    Key key,
    @required this.card,
    this.onPress,
    this.onLongPress,
    this.selectMode = false
  }): super(key: key);

  @override
  _StackCardWidgetState createState() => _StackCardWidgetState();
}

class _StackCardWidgetState extends State<StackCardWidget> {

  bool selected = false;
@override
  void didUpdateWidget(StackCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(isSelectModeClosed(oldWidget.selectMode)) {
      setState(() {
        selected = false;
      });
    }
}
  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    return GestureDetector(
      onLongPress: onLongPress,
      child: RaisedButton(
        color: _getColorByCardSelectedState(selected),
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
    );
  }

  bool isSelectModeClosed(bool oldState) => oldState && !widget.selectMode;

  Color _getColorByCardSelectedState(bool isSelected) {
    if(isSelected)
      return Colors.amberAccent;

    return _getColorByParentSelectionMode();
  }

  Color _getColorByParentSelectionMode() {
    bool isParentSelectModeOn = widget.selectMode;

    if(isParentSelectModeOn) {
      return Colors.amber.withOpacity(0.5);
    }

    return Colors.amber;
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
    if(widget.selectMode) {
      setState(() {
        selected = !selected;
      });
    }

    try {
      widget.onPress(widget.card);
    } catch (e) {
      print(e.toString());
    }
  }
}
