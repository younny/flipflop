import 'package:flipflop/models/SharedPrefItem.dart';

class Level extends SharedPrefItem {
  final String level;

  Level({
    this.level
  });

  Level.fromPrefs(String level)
      : level = level;

  String toPrefs() => level;

  Level.fromJson(Map json)
      : level = json['level'];

  String toString() => level;

  @override
  bool operator ==(other) {
    return level == other.level;
  }
}