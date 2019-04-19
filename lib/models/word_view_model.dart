abstract class WordViewModel {
  String word;
  String meaning;
  String created;

  WordViewModel({
    this.word,
    this.meaning,
    this.created
  });
  
  WordViewModel.fromMap(Map data);

  Map<String, dynamic> toMap();
}