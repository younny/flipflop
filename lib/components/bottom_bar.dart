import 'package:flipflop/components/dropdown_dialog.dart';
import 'package:flipflop/components/scroll_indicator.dart';
import 'package:flipflop/pages/settings_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final int numOfSteps;
  final double scrollPercent;
  final Function onRightActionCallback;

  const BottomBar({
    this.numOfSteps,
    this.scrollPercent,
    this.onRightActionCallback
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage())
                    );
                  },
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
                  onPressed: () {
                    _showAddToMyStackAlert(context)
                    .then((value) {
                      if(widget.onRightActionCallback != null) {
                        widget.onRightActionCallback(scrollPercent, value);
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _showAddToMyStackAlert(BuildContext context) {
    List<String> folders = ["test1", "test2"];
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DropdownDialog(
          title: "Add to my stack",
          items: folders,
          onChange: (index) {}
        );
      }
    );
  }
}
