import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/models/language_view_model.dart';
import 'package:flipflop/models/level_view_model.dart';
import 'package:flipflop/pages/FlipFlopBlocState.dart';
import 'package:flipflop/utils/shared_prefs_helper.dart';
import 'package:flipflop/widgets/dropdown_dialog.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends FlipFlopBlocState {
  SharedPrefHelper sharedPrefHelper = SharedPrefHelper();

  bool fetching = false;
  FlipFlopBloc ffBloc;
  Language _selectedLang;
  Level _selectedLevel;

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
      //_selectedLevel = ffBloc.selectedLevel;
      //_selectedLang = ffBloc.selectedLang;
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
              builder: (context, snapshot) {
                return StreamBuilder<Object>(
                  stream: ffBloc.selectedLang,
                  builder: (context, langSnapshot) {
                    return SettingItemRow(
                      title: "Change Language to learn",
                      description: langSnapshot.hasData
                            ? (langSnapshot.data as Language).label
                            : 'Korean',
                      onRowPress: () => _showSetLanguageDialog(snapshot.data),
                    );
                  }
                );
              }
            ),
            Divider(),
            StreamBuilder<Object>(
              stream: ffBloc.levels,
              builder: (context, snapshot) {
                return StreamBuilder<Object>(
                  stream: ffBloc.selectedLevel,
                  builder: (context, levelSnapshot) {
                    return SettingItemRow(
                        title: "Set Level",
                        description: levelSnapshot.hasData
                            ? (levelSnapshot.data as Level).level
                            : '0',
                        onRowPress: () => _showSetLevelDialog(levelSnapshot.data)
                    );
                  }
                );
              }
            ),
            Divider(),
            SettingItemRow(
              title: "Send Feedback",
              description: "",
              onRowPress: () => _popUpEmailEditor(),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _showSetLanguageDialog(List<Language> languages) {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DropdownDialog<Language>(
              title: "Select Language",
              value: _selectedLang,
              items: languages,
              supportEditMode: false,
              onDone: (language) {
                _updateLanguage(language);

                Navigator.pop(context);
              },
              onClose: () => Navigator.pop(context),
              onChange: (item) {
              }
          );
        }
    );
  }

  Future<String> _showSetLevelDialog(List<Level> levels) {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DropdownDialog<Level>(
              title: "Select Level",
              value: _selectedLevel,
              items: levels,
              supportEditMode: false,
              onDone: (level) {
                _updateLevel(level);

                Navigator.pop(context);
              },
              onClose: () => Navigator.pop(context),
              onChange: (item) {
              }
          );
        }
    );
  }

  void _popUpEmailEditor() {

  }

  void _updateLanguage(Language item) async {
    ffBloc.lang.add(item);
    setState(() {
      _selectedLang = item;
    });

    await sharedPrefHelper.set('lang', item.toPrefs());
  }

  void _updateLevel(Level item) async {
    ffBloc.level.add(item);
    setState(() {
      _selectedLevel = item;
    });

    await sharedPrefHelper.set('level', item.toPrefs());
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
