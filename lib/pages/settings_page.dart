import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/providers/base_provider.dart';
import 'package:flipflop/utils/shared_prefs_helper.dart';
import 'package:flipflop/widgets/dropdown_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {

  final List<Map<String, dynamic>> settingItems = [
    {
      "title": "Change Language",
      "items": ["ko", "ge"]
    },
    {
      "title": "Set Level",
      "items": ["0", "1", "2"]
    }
  ];

  final Map<String, String> languages = {
    "ko" : "Korean",
    "ge" : "German"
  };

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String selectedLevel = '0';
  String langToLearn = 'ko';
  bool fetching = false;

  @override
  void initState() {
    loadSharedPreferences();
    super.initState();
  }

  void loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = await prefs.get('lang');
    String level = await prefs.get('level');
    setState(() {
      selectedLevel = level ?? '0';
      langToLearn = lang ?? 'ko';
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
            SettingItemRow(
              title: "Change Language to learn",
              description: widget.languages[langToLearn],
              onRowPress: () => _showSetLanguageDialog(widget.settingItems[0]),
            ),
            Divider(),
            SettingItemRow(
                title: "Set Level",
                description: selectedLevel.toString(),
                onRowPress: () => _showSetLevelDialog(widget.settingItems[1])
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

  Future<String> _showSetLanguageDialog(Map<String, Object> item) {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DropdownDialog(
              title: item['title'],
              initialIndex: (item['items'] as List).indexOf(langToLearn),
              items: item['items'],
              supportEditMode: false,
              onDone: (language) {
                _updateLanguage(language);

                Navigator.pop(context);
              },
              onClose: () => Navigator.pop(context),
              onChange: (index) {

              }
          );
        }
    );
  }

  Future<String> _showSetLevelDialog(Map<String, Object> item) {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DropdownDialog(
              title: item['title'],
              initialIndex: int.parse(selectedLevel),
              items: item['items'],
              supportEditMode: false,
              onDone: (level) {
                _updateLevel(level);

                Navigator.pop(context);
              },
              onClose: () => Navigator.pop(context),
              onChange: (index) {

              }
          );
        }
    );
  }

  void _popUpEmailEditor() {

  }

  void _updateLanguage(String item) async {
    setState(() {
      langToLearn = item;
      fetching = true;
    });

    await setPrefs('lang', langToLearn);
    final flipFlopBloc = Provider.of<FlipFlopBloc>(context);
    flipFlopBloc.setLang = langToLearn;
    setState(() {
      fetching = false;
    });
  }

  void _updateLevel(String item) async {
    print("Selected item : $item");
    setState(() {
      selectedLevel = item;
      fetching = true;
    });

    await setPrefs('level', selectedLevel);
    final flipFlopBloc = Provider.of<FlipFlopBloc>(context);
    flipFlopBloc.setLevel = selectedLevel;
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
