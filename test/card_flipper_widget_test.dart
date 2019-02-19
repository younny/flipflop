import 'package:flip/components/card_list.dart';
import 'package:flip/models/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithMaterial(Widget child) {
  return MaterialApp(
    home: Material(
      child: child,
    ),
  );
}

void main() {
  testWidgets('Card list renders a card correctly', (WidgetTester tester) async {
    final List<WordViewModel> cards = [
      WordViewModel(
        word: 'TEST',
        meaning: 'This is test'
      )
    ];

    final CardListWidget cardList = CardListWidget(
      cards: cards,
      onScroll: (double scrollPercent) {
      },
    );

    await tester.pumpWidget(wrapWithMaterial(cardList));

    expect(find.text('TEST'), findsNWidgets(2));

  });

  testWidgets('Card list scrolling', (WidgetTester tester) async {
    final Key listKey = Key('card-list');

    double percent = 0.0;
    const String mockMeaning = 'This is test';

    final List<WordViewModel> cards = [
      WordViewModel(
          word: 'TEST',
          meaning: mockMeaning
      ),
      WordViewModel(
          word: 'TEST2',
          meaning: '$mockMeaning 2'
      )
    ];

    final CardListWidget cardList = CardListWidget(
      key: listKey,
      cards: cards,
      onScroll: (double scrollPercent) {
        percent = scrollPercent;
      },
    );

    await tester.pumpWidget(wrapWithMaterial(cardList));

    await tester.fling(find.byWidget(cardList), Offset(-800.0, 0.0), 150);

    await tester.pumpAndSettle(Duration(milliseconds: 100));

    expect(percent > 0.0, isTrue);

    expect(find.text('TEST'), findsNothing);

    expect(find.text('TEST2'), findsNWidgets(2));

  });

  testWidgets('Card flipped correctly', (WidgetTester tester) async {
    final Key listKey = Key('card-list');

    const String mockMeaning = 'This is test';

    final List<WordViewModel> cards = [
      WordViewModel(
          word: 'TEST',
          meaning: mockMeaning
      ),
      WordViewModel(
          word: 'TEST2',
          meaning: '$mockMeaning 2'
      )
    ];

    final CardListWidget cardList = CardListWidget(
      key: listKey,
      cards: cards,
      onScroll: (double scrollPercent) {},
    );

    await tester.pumpWidget(wrapWithMaterial(cardList));

    await tester.tap(find.byKey(listKey));

    expect(find.text(' $mockMeaning'), findsOneWidget);

    await tester.fling(find.byWidget(cardList), Offset(-800.0, 0.0), 150);

    await tester.pumpAndSettle(Duration(milliseconds: 100));

    expect(find.text('TEST'), findsNothing);

    expect(find.text('TEST2'), findsNWidgets(2));

    await tester.tap(find.byKey(listKey));

    await tester.pumpAndSettle(Duration(milliseconds: 150));

    expect(find.text(' $mockMeaning 2'), findsOneWidget);
  });
}