import 'package:flipflop/components/scroll_indicator.dart';
import 'package:flipflop/pages/settings_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final int numOfSteps;
  final double scrollPercent;

  const BottomBar({
    this.numOfSteps,
    this.scrollPercent
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
                      print("Save to ${value}");
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
    List<String> folders = [];
    String selectedFolder;
    int selectedIndex = 0;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        int index = 0;

        return AlertDialog(
          title: Text("Add to my stack"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButton<int>(
                  value: folders.length == 0 ? null : selectedIndex,
                  items: folders.map((folderName) {
                    return DropdownMenuItem(
                      value: index++,
                      child: Text(folderName),
                    );
                  }).toList()
                  ..add(DropdownMenuItem(
                    value: folders.length,
                    child: Row(
                      children: <Widget>[
                        Text("New folder"),
                        Icon(
                          Icons.library_add,
                          color: Colors.amber
                        )
                      ],
                    )
                  )),
                  hint: Text("Select folder"),
                  onChanged: (index) {
                      if(index == folders.length) {
                        _showNewFolderFieldAlert(context)
                            .then((newName) {
                          if(newName != null) {
                            print("New name: $newName");
                            folders.add(newName);
                            selectedIndex++;

                          }
                        });
                      } else {
                        selectedIndex = index;
                        selectedFolder = folders[index];
                      }
                      print("index $selectedIndex selected");
                  },
                )
              ],
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop(selectedFolder);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(selectedFolder);
              },
            )
          ],
        );
      }
    );
  }

  Future<String> _showNewFolderFieldAlert(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    String newFolderName;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter name"),
            content: TextField(
              autofocus: true,
              onSubmitted: (text) {
                newFolderName = _controller.text;
                Navigator.of(context).pop(newFolderName);
              },
              controller: _controller,
              cursorColor: Colors.amber,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  newFolderName = _controller.text;

                  Navigator.of(context).pop(newFolderName);
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
        });
  }
}
