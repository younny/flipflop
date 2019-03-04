class WordViewModel {
  final String word;
  final String meaning;
  final String pronunciation;
  final String category;
  final String created;
  final String lang;

  WordViewModel({
    this.word,
    this.meaning,
    this.pronunciation,
    this.category,
    this.created,
    this.lang
  });

  WordViewModel.fromJson(Map json)
      : word = json['word'],
        meaning = json['meaning'],
        pronunciation = json['pronunciation'],
        category = json['catetory'],
        created = json['created'],
        lang = json['lang'];

}