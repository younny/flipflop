import 'package:flipflop/widgets/scroll_indicator.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final int numOfSteps;
  final double scrollPercent;
  final VoidCallback onLeftIconPress;
  final VoidCallback onRightIconPress;
  const BottomBar({
    this.numOfSteps,
    this.scrollPercent,
    this.onLeftIconPress,
    this.onRightIconPress
  });

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {
    int numOfSteps = widget.numOfSteps;
    double scrollPercent = widget.scrollPercent;
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.settings),
                  tooltip: "settings",
                  onPressed: widget.onLeftIconPress ?? () {},
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 5.0,
                  child: ScrollIndicator(
                      numOfSteps: numOfSteps,
                      scrollPercent: scrollPercent
                  ),
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add),
                  tooltip: "add to my stack",
                  onPressed: widget.onRightIconPress ?? () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
