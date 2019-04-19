import 'package:flipflop/models/word_view_model.dart';

class Korean extends WordViewModel {
  final String word;
  final String meaning;
  final String pronunciation;
  final String created;

  Korean({
    this.word,
    this.meaning,
    this.pronunciation,
    this.created
  }) : super(
      word: word,
      meaning: meaning,
      created: created
  );

  Korean.fromMap(Map map)
  : word = map['word'],
    meaning = map['meaning'],
    pronunciation = map['pronunciation'],
    created = map['created'].toString();

  @override
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'meaning': meaning,
      'pronunciation': pronunciation,
      'created': created
    };
  }
}