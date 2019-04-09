import 'package:flutter/material.dart';

class DropdownDialog<T> extends StatefulWidget {
  DropdownDialog({
    this.title,
    this.value,
    this.items = const [],
    this.hint = "",
    this.onChange,
    this.onClose,
    this.onDone,
    this.doneText = "Done",
    this.closeText = "Close",
    this.supportEditMode = true
  });

  final String title;
  final T value;
  final List<T> items;
  final String hint;
  final ValueChanged onChange;
  final ValueChanged onDone;
  final VoidCallback onClose;
  final String doneText;
  final String closeText;
  final bool supportEditMode;

  @override
  _DropdownDialogState createState() => _DropdownDialogState<T>();
}

class _DropdownDialogState<T> extends State<DropdownDialog> {

  T selectedItem;
  bool editMode = false;

  final TextEditingController _controller = TextEditingController();
  final Function _validate = (text) => text.isEmpty ? "Must not be empty." : null;

  @override
  void initState() {
    selectedItem = widget.value;
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
                Navigator.of(context).pop();
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
    var items = widget.items ?? [];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButton<T>(
          value: selectedItem,
          items: items.map((dynamic item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          hint: Text(widget.hint),
          onChanged: (T item) {
            setState(() {
              selectedItem = item;
              widget.onChange(selectedItem);
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
