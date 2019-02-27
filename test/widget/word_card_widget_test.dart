import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flip/components/wordcard_widget.dart';
import 'package:flip/models/word_view_model.dart';
import 'package:flip/utils/string_formatter.dart';

Widget wrapWithMaterial(Widget child) {
  return MaterialApp(
    home: Material(
      child: child,
    ),
  );
}

void main() {
  testWidgets('renders front view of a card', (WidgetTester tester) async {

    final key = Key('word-card');
    const String word = 'TEST';
    final WordViewModel viewModel = WordViewModel(
      word: word
    );

    final wordCard = WordCardWidget(
      key: key,
      viewModel: viewModel,
      flipped: false,
    );

    await tester.pumpWidget(wrapWithMaterial(wordCard));

    expect(wordCard.viewModel.word, equals(word));

    expect(find.text(word), findsOneWidget);

  });

  testWidgets('renders back view of a card', (WidgetTester tester) async {

    final key = Key('word-card');
    const String word = 'TEST';
    final String meaning = 'This is test.';
    final WordViewModel viewModel = WordViewModel(
        word: word,
        meaning: meaning
    );

    final wordCard = WordCardWidget(
      key: key,
      viewModel: viewModel,
      flipped: true,
    );

    await tester.pumpWidget(wrapWithMaterial(wordCard));

    expect(wordCard.viewModel.meaning, equals(meaning));

    expect(find.text(StringFormatter.formatMeaning(viewModel.meaning)), findsOneWidget);

  });

  testWidgets('renders back view of a card with long length of meaning', (WidgetTester tester) async {

    final key = Key('word-card');
    const String word = 'TEST';
    final String meaning = 'This is test.This is test.This isTh'
          'is is test.This is test.This is test. test.This This is test.'
          'is test.This is test.This is test.This is test.This is test.';

    final WordViewModel viewModel = WordViewModel(
        word: word,
        meaning: meaning
    );

    final wordCard = WordCardWidget(
      key: key,
      viewModel: viewModel,
      flipped: true,
    );

    await tester.pumpWidget(wrapWithMaterial(wordCard));

    expect(wordCard.viewModel.meaning, equals(meaning));

    expect(find.text(StringFormatter.formatMeaning(viewModel.meaning)), findsOneWidget);

  });
}
