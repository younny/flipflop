import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/utils/string_formatter.dart';
import 'package:flipflop/widgets/wordcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_wrapper.dart';

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

    await tester.pumpWidget(wrap(wordCard));

    expect(wordCard.viewModel.word, equals(word));

    expect(find.text(StringFormatter.formatWord(viewModel.word)), findsOneWidget);

  });

  testWidgets('renders front view of a card with null word', (WidgetTester tester) async {

    final key = Key('word-card');
    String word;
    final WordViewModel viewModel = WordViewModel(
        word: word
    );

    final wordCard = WordCardWidget(
      key: key,
      viewModel: viewModel,
      flipped: false,
    );

    await tester.pumpWidget(wrap(wordCard));

    expect(wordCard.viewModel.word, equals(word));

    expect(find.text(StringFormatter.formatWord(viewModel.word)), findsOneWidget);

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

    await tester.pumpWidget(wrap(wordCard));

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

    await tester.pumpWidget(wrap(wordCard));

    expect(wordCard.viewModel.meaning, equals(meaning));

    expect(find.text(StringFormatter.formatMeaning(viewModel.meaning)), findsOneWidget);

  });

  testWidgets('renders back view of a card with null meaning', (WidgetTester tester) async {

    final key = Key('word-card');
    const String word = 'TEST';

    final WordViewModel viewModel = WordViewModel(
        word: word,
        meaning: null
    );

    final wordCard = WordCardWidget(
      key: key,
      viewModel: viewModel,
      flipped: true,
    );

    await tester.pumpWidget(wrap(wordCard));

    expect(wordCard.viewModel.meaning, equals(null));

    expect(find.text(StringFormatter.formatMeaning(viewModel.meaning)), findsOneWidget);

  });
}
