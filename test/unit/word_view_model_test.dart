import 'package:test/test.dart';
import 'package:flipflop/models/word_view_model.dart';

void main() {

  test("should be equal when all data properties have same values.", () {
    DateTime dateTime = DateTime.now();

    final word1 = WordViewModel(
      word: "test1",
      meaning: "blah",
      pronunciation: "blah",
      created: dateTime,
      level: 0,
      lang: "en",
      category: "test"
    );

    final word2 = WordViewModel(
        word: "test1",
        meaning: "blah",
        pronunciation: "blah",
        created: dateTime,
        level: 0,
        lang: "en",
        category: "test"
    );

    expect(word1 == word2, isTrue);
  });
}