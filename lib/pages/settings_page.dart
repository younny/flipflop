import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/constant/keys.dart';
import 'package:flipflop/models/SharedPrefItem.dart';
import 'package:flipflop/models/language_view_model.dart';
import 'package:flipflop/models/level_view_model.dart';
import 'package:flipflop/pages/FlipFlopBlocState.dart';
import 'package:flipflop/utils/shared_prefs_helper.dart';
import 'package:flipflop/utils/url_launcher_wrapper.dart';
import 'package:flipflop/widgets/dropdown_dialog.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends FlipFlopBlocState {
  final SharedPrefHelper sharedPrefHelper = SharedPrefHelper.instance;

  bool fetching = false;
  FlipFlopBloc ffBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _setBloc();
  }

  void _setBloc() {
    setState(() {
      ffBloc = bloc(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<Object>(
              stream: ffBloc.languages,
              builder: (context, langListSnapshot) {
                return StreamBuilder<Object>(
                  stream: ffBloc.selectedLang,
                  builder: (context, langSnapshot) {
                    return SettingItemRow(
                      title: "Change Language to learn",
                      description: langSnapshot.hasData
                            ? (langSnapshot.data as Language).label
                            : 'Korean',
                      onRowPress: () =>
                          _showDropdownDialog(langListSnapshot.data, langSnapshot.data),
                    );
                  }
                );
              }
            ),
            Divider(),
            StreamBuilder<Object>(
              stream: ffBloc.levels,
              builder: (context, levelListSnapshot) {
                return StreamBuilder<Object>(
                  stream: ffBloc.selectedLevel,
                  builder: (context, levelSnapshot) {
                    return SettingItemRow(
                        title: "Set Level",
                        description: levelSnapshot.hasData
                            ? (levelSnapshot.data as Level).level
                            : '0',
                        onRowPress: () =>
                            _showDropdownDialog(levelListSnapshot.data, levelSnapshot.data)
                    );
                  }
                );
              }
            ),
            Divider(),
            SettingItemRow(
              title: "Send Feedback",
              description: "",
              onRowPress: () => _openEmailEditor(),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _showDropdownDialog<T>(List<T> items, T currentItem) {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DropdownDialog<T>(
              title: "Select ${currentItem.runtimeType}",
              value: currentItem,
              items: items,
              supportEditMode: false,
              onDone: (newItem) {
                _updateLanguageToBloc(newItem);

                Navigator.pop(context);
              },
              onClose: () => Navigator.pop(context),
              onChange: (item) {
              }
          );
        }
    );
  }

  void _updateLanguageToBloc(SharedPrefItem item) async {
    Type type = item.runtimeType;
    String key = "$type".toLowerCase();

    ffBloc.getItem(type).add(item);
    sharedPrefHelper.set<String>(key, item.toPrefs());
  }

  void _openEmailEditor() {
    try {
      launchURL(Keys.URL_EMAIL_TYPE, "flipflop@gmail.com");
    } catch(e) {
      print(e);
    }
  }
}

class SettingItemRow extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onRowPress;

  const SettingItemRow({
    Key key,
    this.title,
    this.description,
    this.onRowPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.all(0.0),
      onPressed: onRowPress,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, top: 4.0),
              child: Text(
                description,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
