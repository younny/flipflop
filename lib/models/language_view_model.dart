class Language {
  final String code;
  final String label;

  Language({
    this.code,
    this.label
  });

  Language.fromJson(Map json)
      : code = json['code'],
        label = json['label'];

  String toString() => label;

  @override
  bool operator ==(other) {
    return (code == other.code && label == other.label);
  }
}