import 'package:flip/components/card_list.dart';
import 'package:flip/models/word_view_model.dart';
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
  testWidgets('card list renders a card', (WidgetTester tester) async {
    final List<WordViewModel> cards = [
      WordViewModel(
        word: 'TEST',
        meaning: 'This is test'
      )
    ];

    final CardListWidget cardList = CardListWidget(
      cards: cards
    );

    await tester.pumpWidget(wrapWithMaterial(cardList));
    expect(find.text('TEST'), findsNWidgets(2));

  });

  testWidgets('scrolling card list', (WidgetTester tester) async {
    final Key listKey = Key('card-list');

    double percent = 0.0;

    final List<WordViewModel> cards = [
      WordViewModel(
        word: 'TEST'
      ),
      WordViewModel(
        word: 'TEST2'
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

  testWidgets('flip a single card', (WidgetTester tester) async {
    final Key listKey = Key('card-list');
    final String firstCardMeaning = 'This is test';
    final List<WordViewModel> cards = [
      WordViewModel(
        word: 'TEST',
        meaning: firstCardMeaning
      )
    ];

    final CardListWidget cardList = CardListWidget(
      key: listKey,
      cards: cards
    );

    await tester.pumpWidget(wrapWithMaterial(cardList));

    await tester.tap(find.byKey(listKey));

    expect(find.text(': $firstCardMeaning'), findsOneWidget);
  });

  testWidgets('flip multiple cards', (WidgetTester tester) async {
    final Key listKey = Key('card-list');
    final String firstCardMeaning = 'This is test';
    final String secondCardMeaning = 'This is test2';
    final List<WordViewModel> cards = [
      WordViewModel(
        word: 'TEST',
        meaning: firstCardMeaning
      ),
      WordViewModel(
        word: 'TEST2',
        meaning: secondCardMeaning
      )
    ];

    final CardListWidget cardList = CardListWidget(
      key: listKey,
      cards: cards
    );

    await tester.pumpWidget(wrapWithMaterial(cardList));

    await tester.tap(find.byKey(listKey));

    expect(find.text(': $firstCardMeaning'), findsOneWidget);

    await tester.fling(find.byWidget(cardList), Offset(-800.0, 0.0), 150);

    await tester.pumpAndSettle(Duration(milliseconds: 100));

    expect(find.text('TEST'), findsNothing);

    expect(find.text('TEST2'), findsNWidgets(2));

    await tester.tap(find.byKey(listKey));

    await tester.pumpAndSettle(Duration(milliseconds: 150));

    expect(find.text(': $secondCardMeaning'), findsOneWidget);
  });


//  testWidgets('handles success case of cards loading correctly', (WidgetTester tester) async {
//    List<WordViewModel> results = [];
//    bool success = false;
//
//    expect(success, isTrue);
//  });
//
//  testWidgets('handles failure case of cards loading correctly', (WidgetTester tester) async {
//    List<WordViewModel> results = [];
//    bool failed = false;
//
//    expect(failed, isTrue);
//  });
}