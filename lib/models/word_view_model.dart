class WordViewModel {
  final String word;
  final String meaning;
  final String pronunciation;
  final String category;
  final int level;
  final DateTime created;
  final String lang;

  WordViewModel({
    this.word,
    this.meaning,
    this.pronunciation,
    this.category,
    this.level,
    this.created,
    this.lang
  });

  WordViewModel.fromJson(Map json)
      : word = json['word'],
        meaning = json['meaning'],
        pronunciation = json['pron'],
        category = json['catetory'],
        level = json['level'],
        created = json['created'],
        lang = json['lang'];

}