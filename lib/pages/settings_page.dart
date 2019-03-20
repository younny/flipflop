import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/models/language_view_model.dart';
import 'package:flipflop/models/level_view_model.dart';
import 'package:flipflop/providers/base_provider.dart';
import 'package:flipflop/utils/shared_prefs_helper.dart';
import 'package:flipflop/widgets/dropdown_dialog.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Level _selectedLevel = Level(level: '0');
  Language _selectedLang = Language(code: 'ko', label: 'Korean');
  bool fetching = false;

  String selectLabelByCode(String code) {
    switch(code) {
      case 'ko':
        return 'Korean';
      case 'ge':
        return 'German';
      default:
        return '';
    }
  }
  @override
  void initState() {
    loadSharedPreferences();
    super.initState();
  }

  void loadSharedPreferences() async {
    String lang = await getPrefs('lang');
    String level = await getPrefs('level');

    setState(() {
      _selectedLevel = level != null ? Level(level: level) : _selectedLevel;
      _selectedLang = lang != null ? Language(code: lang, label: selectLabelByCode(lang)) : _selectedLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ffBloc = Provider.of<FlipFlopBloc>(context);

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
                return SettingItemRow(
                  title: "Change Language to learn",
                  description: _selectedLang.label,
                  onRowPress: () => _showSetLanguageDialog(snapshot.data),
                );
              }
            ),
            Divider(),
            StreamBuilder<Object>(
              stream: ffBloc.levels,
              builder: (context, snapshot) {
                return SettingItemRow(
                    title: "Set Level",
                    description: _selectedLevel.level,
                    onRowPress: () => _showSetLevelDialog(snapshot.data)
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
    final flipFlopBloc = Provider.of<FlipFlopBloc>(context);
    setState(() {
      _selectedLang = item;
      fetching = true;
    });

    await setPrefs('lang', _selectedLang.code);
    flipFlopBloc.setLang = _selectedLang.code;
    setState(() {
      fetching = false;
    });
  }

  void _updateLevel(Level item) async {
    setState(() {
      _selectedLevel = item;
      fetching = true;
    });

    await setPrefs('level', _selectedLevel.level);
    final flipFlopBloc = Provider.of<FlipFlopBloc>(context);
    flipFlopBloc.setLevel = _selectedLevel.level;
    setState(() {
      fetching = false;
    });
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
