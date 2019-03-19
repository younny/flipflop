import 'package:flutter/material.dart';

class DropdownDialog extends StatefulWidget {
  DropdownDialog({
    this.title,
    this.items = const [],
    this.initialIndex = 0,
    this.hint = "",
    this.onChange,
    this.onClose,
    this.onDone,
    this.doneText = "Done",
    this.closeText = "Close",
    this.supportEditMode = true
  });

  final String title;
  final List<String> items;
  final int initialIndex;
  final String hint;
  final ValueChanged<int> onChange;
  final ValueChanged<String> onDone;
  final VoidCallback onClose;
  final String doneText;
  final String closeText;
  final bool supportEditMode;

  @override
  _DropdownDialogState createState() => _DropdownDialogState();
}

class _DropdownDialogState extends State<DropdownDialog> {

  String selectedItem;
  int selectedIndex;
  bool editMode = false;

  final TextEditingController _controller = TextEditingController();
  final Function _validate = (text) => text.isEmpty ? "Must not be empty." : null;

  @override
  void initState() {
    if(widget.items.length > 0) {
      selectedItem = widget.items[0];
    }

    selectedIndex = widget.initialIndex;

    super.initState();
  }
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
              selectedItem = editMode ? _controller.text : selectedItem;
              try {
                widget.onDone(selectedItem);
              } catch (e) {
                print(e);
                Navigator.of(context).pop(selectedItem);
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
                selectedItem = widget.items[selectedIndex];
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButton<int>(
          value: items.isEmpty ? null : selectedIndex,
          items: items.map((itemName) {
            return DropdownMenuItem(
              value: index++,
              child: Text(itemName),
            );
          }).toList(),
          hint: Text(widget.hint),
          onChanged: (index) {
            setState(() {
              selectedIndex = index;
              selectedItem = items[selectedIndex];
              widget.onChange(selectedIndex);
            });
          },
        ),
        widget.supportEditMode
        ? IconButton(
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
        : Container(width: 0, height: 0)
      ],
    );
  }
}
