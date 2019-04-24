import 'package:flipflop/models/word_view_model.dart';

class Korean extends WordViewModel {
  final String word;
  final String meaning;
  final String pronunciation;
  final String created;
  final String lang;

  Korean({
    this.word,
    this.meaning,
    this.pronunciation,
    this.created,
    this.lang = "ko"
  }) : super(
      word: word,
      meaning: meaning,
      lang: lang
  );

  Korean.fromMap(Map map)
  : word = map['word'],
    meaning = map['meaning'],
    pronunciation = map['pronunciation'],
    created = map['created'].toString(),
    lang = map['lang'];

  @override
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'meaning': meaning,
      'pronunciation': pronunciation,
      'created': created,
      'lang': lang
    };
  }
}