import 'package:flipflop/models/word_view_model.dart';

class German extends WordViewModel {
  final String word;
  final String meaning;
  final String form;
  final String plural;
  final String oppo;
  final String created;

  German({
    this.word,
    this.meaning,
    this.form = "",
    this.plural = "",
    this.oppo = "",
    this.created
  }) : super(
    word: word,
    meaning: meaning,
    created: created
  );

  German.fromMap(Map map)
      : word = map['word'],
        meaning = map['meaning'],
        form = map['form'],
        plural = map['plural'],
        oppo = map['oppo'],
        created = map['created'].toString();

  @override
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'meaning': meaning,
      'form': form,
      'plural': plural,
      'oppo': oppo,
      'created': created
    };
  }
}