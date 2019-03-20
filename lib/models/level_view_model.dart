class Level {
  final String level;

  Level({
    this.level
  });

  Level.fromJson(Map json)
      : level = json['level'];

  String toString() => level;

  @override
  bool operator ==(other) {
    return level == other.level;
  }
}