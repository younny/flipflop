import 'package:flipflop/models/korean.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_wrapper.dart';

void main() {
  testWidgets('card list renders a card', (WidgetTester tester) async {
    final List<WordViewModel> cards = [
      Korean(
        word: 'TEST',
        meaning: 'This is test'
      )
    ];

    final CardListWidget cardList = CardListWidget(
      cards: cards
    );

    await tester.pumpWidget(wrap(cardList));
    expect(find.text('TEST'), findsNWidgets(2));

  });

  testWidgets('flip a single card', (WidgetTester tester) async {
    final Key listKey = Key('card-list');
    final String firstCardMeaning = 'This is test';
    final List<WordViewModel> cards = [
      Korean(
        word: 'TEST',
        meaning: firstCardMeaning
      )
    ];

    final CardListWidget cardList = CardListWidget(
      key: listKey,
      cards: cards
    );

    await tester.pumpWidget(wrap(cardList));

    await tester.tap(find.byKey(listKey));

    expect(find.text(': $firstCardMeaning'), findsOneWidget);
  });

  testWidgets('flip multiple cards', (WidgetTester tester) async {
    final Key listKey = Key('card-list');
    final String firstCardMeaning = 'This is test';
    final String secondCardMeaning = 'This is test2';
    final List<WordViewModel> cards = [
      Korean(
        word: 'TEST',
        meaning: firstCardMeaning
      ),
      Korean(
        word: 'TEST2',
        meaning: secondCardMeaning
      )
    ];

    final CardListWidget cardList = CardListWidget(
      key: listKey,
      cards: cards
    );

    await tester.pumpWidget(wrap(cardList));

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