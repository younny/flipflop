import 'package:flip/components/scroll_indicator.dart';
import 'package:flip/pages/settings_page.dart';
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
                child: Icon(
                    Icons.add
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
