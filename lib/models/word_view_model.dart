abstract class WordViewModel {
  String word;
  String meaning;
  String lang;

  WordViewModel({
    this.word,
    this.meaning,
    this.lang
  });

  Map<String, dynamic> toMap();
}