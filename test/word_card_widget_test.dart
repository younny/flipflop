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
    bool isTapped = false;
    final key = Key('word-card');
    final onTap = () {
      isTapped = true;
    };
    final wordCard = WordCardWidget(
      key: key,
      word: 'TEST',
      onTap: onTap
    );

    await tester.pumpWidget(wrapWithMaterial(wordCard));

    expect(wordCard.word, equals('TEST'));

    expect(find.text('TEST'), findsOneWidget);

    await tester.tap(find.byKey(key));

    expect(isTapped, isTrue);

  });
}
