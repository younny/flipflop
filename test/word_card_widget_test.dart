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
  testWidgets('Word card renders correctly', (WidgetTester tester) async {

    final key = Key('word-card');

    final WordViewModel viewModel = WordViewModel(
      word: 'TEST',
      meaning: 'testtesttesttesttesttesttesttesttesttestte'
          'sttesttesttesttesttesttesttesttesttesttesttestte'
          'sttesttesttesttesttesttesttesttesttesttesttesttes'
          'sttesttesttesttesttesttesttesttesttesttesttesttes'
          'sttesttesttesttesttesttesttesttesttesttesttesttes'
          'sttesttesttesttesttesttesttesttesttesttesttesttes'
          'sttesttesttesttesttesttesttesttesttesttesttesttes'
          'ttesttesttesttesttesttesttesttesttesttesttesttest'
          'testtesttesttesttesttesttesttest'
    );

    final wordCard = WordCardWidget(
      key: key,
      viewModel: viewModel
    );

    await tester.pumpWidget(wrapWithMaterial(wordCard));

    expect(wordCard.viewModel.word, equals('TEST'));

    expect(find.text('TEST'), findsOneWidget);

  });
}
