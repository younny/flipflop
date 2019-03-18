import 'package:flutter/material.dart';

class DropdownDialog extends StatefulWidget {
  DropdownDialog({
    this.title,
    @required this.items,
    this.onChange,
    this.onClose,
    this.onDone,
    this.doneText = "Done",
    this.closeText = "Close"
  });

  final String title;
  final List<String> items;
  final ValueChanged<int> onChange;
  final ValueChanged<String> onDone;
  final VoidCallback onClose;
  final String doneText;
  final String closeText;

  @override
  _DropdownDialogState createState() => _DropdownDialogState();
}

class _DropdownDialogState extends State<DropdownDialog> {

  String selectedFolder;
  int selectedIndex = 0;
  bool editMode = false;

  final TextEditingController _controller = TextEditingController();
  final Function _validate = (text) => text.isEmpty ? "Must not be empty." : null;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
          child: editMode ? _buildEditModeView() : _buildDropdownView()
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(widget.doneText),
          onPressed: () {
            setState(() {
              selectedFolder = _controller.text;
              try {
                widget.onDone(selectedFolder);
              } catch (e) {
                print(e);
                Navigator.of(context).pop(selectedFolder);
              }
            });
          },
        ),
        FlatButton(
          child: Text(editMode ? "Cancel" : widget.closeText),
          onPressed: () {
            if(editMode) {
              setState(() {
                editMode = false;
                selectedFolder = widget.items[selectedIndex];
              });
              return;
            }
            try {
              widget.onClose();
            } catch (e) {
              print(e);
              Navigator.of(context).pop();
            }
          },
        )
      ]
    );
  }

  Widget _buildEditModeView() {
    return Form(
        onWillPop: () => Future.value(false),
        autovalidate: true,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          validator: _validate,
          decoration: InputDecoration(
              hintText: "New Folder 1"
          ),
        )
    );
  }

  Widget _buildDropdownView() {
    var items = widget.items;
    int index = 0;

    return Row(
      children: <Widget>[
        DropdownButton<int>(
          value: items.length == 0 ? null : selectedIndex,
          items: items.map((folderName) {
            return DropdownMenuItem(
              value: index++,
              child: Text(folderName),
            );
          }).toList(),
          hint: Text("Select folder"),
          onChanged: (index) {
            setState(() {
              selectedIndex = index;
              selectedFolder = items[selectedIndex];
              widget.onChange(selectedIndex);
            });
          },
        ),
        IconButton(
          icon: Icon(
              Icons.library_add,
              color: Colors.amber
          ),
          onPressed: () {
            setState(() {
              editMode = true;
            });
          },
        )
      ],
    );
  }
}
