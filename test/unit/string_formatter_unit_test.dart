import 'package:test/test.dart';

import 'package:flip/utils/string_formatter.dart';

void main() {
  test("format word with some value", () {
    String source = "apple";
    String result = StringFormatter.formatWord(source);

    expect(result, equals(source));
  });

  test("format word with null value", () {
    String source;
    String result = StringFormatter.formatWord(source);

    expect(result, equals(StringFormatter.TAG_UNAVAILABLE));
  });

  test("format word with empty value", () {
    String source = "";
    String result = StringFormatter.formatWord(source);

    expect(result, equals(StringFormatter.TAG_UNAVAILABLE));
  });

  test("format meaning with some value", () {
    String source = "This is test meaning.";
    String result = StringFormatter.formatMeaning(source);

    expect(result, equals(': $source'));
  });

  test("format meaning with null value", () {
    String source;
    String result = StringFormatter.formatMeaning(source);

    expect(result, equals(': ${StringFormatter.TAG_UNAVAILABLE}'));
  });

  test("format meaning with empty value", () {
    String source = "";
    String result = StringFormatter.formatMeaning(source);

    expect(result, equals(': ${StringFormatter.TAG_UNAVAILABLE}'));
  });

  test("format pronunciation with some value", () {
    String source = "sa-g-wa";
    String result = StringFormatter.formatPronunciation(source);

    expect(result, equals('[$source]'));
  });

  test("format pronunciation with null value", () {
    String source;
    String result = StringFormatter.formatPronunciation(source);

    expect(result, equals('[${StringFormatter.TAG_UNAVAILABLE}]'));
  });

  test("format pronunciation with empty value", () {
    String source = "";
    String result = StringFormatter.formatPronunciation(source);

    expect(result, equals('[${StringFormatter.TAG_UNAVAILABLE}]'));
  });
}