import 'package:flipflop/models/db_model.dart';

class WordViewModel {
  final int id;
  final String word;
  final String meaning;
  final String pronunciation;
  final String category;
  final int level;
  final DateTime created;
  final String lang;

  WordViewModel({
    this.id,
    this.word,
    this.meaning,
    this.pronunciation,
    this.category,
    this.level,
    this.created,
    this.lang
  });

  WordViewModel.fromJson(Map json)
      : id = json['id'],
        word = json['word'],
        meaning = json['meaning'],
        pronunciation = json['pron'],
        category = json['catetory'],
        level = json['level'],
        created = json['created'],
        lang = json['lang'];

  WordViewModel.fromMap(Map map)
      : id = map[columnId],
        word = map[columnWord],
        meaning = map[columnMeaning],
        pronunciation = map[columnPron],
        category = map[columnCategory],
        level = map[columnLevel],
        created = DateTime.now(),
        lang = map[columnLang];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      columnWord: word,
      columnMeaning: meaning,
      columnPron: pronunciation,
      columnCategory: category,
      columnLevel: level,
      columnLang: lang,
    };

    if(id != null) {
      map[columnId] = id;
    }
    return map;
  }

}