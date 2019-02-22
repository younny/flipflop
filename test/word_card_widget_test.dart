import 'package:flip/models/meaning.dart';
import 'package:flip/models/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flip/components/wordcard_widget.dart';

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
    final Meaning meaning = Meaning(
      source: 'This is test.'
    );
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

    expect(find.text(meaning.format()), findsOneWidget);

  });

  testWidgets('renders back view of a card with long length of meaning', (WidgetTester tester) async {

    final key = Key('word-card');
    const String word = 'TEST';
    final Meaning meaning = Meaning(
      source: 'This is test.This is test.This isTh'
          'is is test.This is test.This is test. test.This This is test.'
          'is test.This is test.This is test.This is test.This is test.'
    );

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

    expect(find.text(meaning.format()), findsOneWidget);

  });
}
