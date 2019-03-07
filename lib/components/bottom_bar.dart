import 'package:flipflop/components/scroll_indicator.dart';
import 'package:flipflop/pages/settings_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int numOfSteps;
  final double scrollPercent;

  const BottomBar({
    this.numOfSteps,
    this.scrollPercent
  });

  @override
  Widget build(BuildContext context) {
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
                    _showAddToMyStackAlert(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddToMyStackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add to my stack"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Select folder."),
              ],
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
}
