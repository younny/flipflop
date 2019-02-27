import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flip/components/card_flipper.dart';
import 'package:flip/components/wordcard_widget.dart';
import 'package:flip/models/word_view_model.dart';
import 'package:flip/components/card_list.dart';
import '../helper/widget_wrapper.dart';

final Key listKey = Key("card-list");
final mockCards = <WordViewModel>[
  WordViewModel(
      word: '사과',
      meaning: 'Apple',
      pronunciation: 'sa-g-wa',
      created: '27 Feb 2019',
      category: 'fruit'
  ),
  WordViewModel(
      word: '포도',
      meaning: 'Grape',
      pronunciation: 'po-do',
      created: '27 Feb 2019',
      category: 'fruit'
  ),
  WordViewModel(
      word: '수박',
      meaning: 'Watermelon',
      pronunciation: 'soo-bak',
      created: '27 Feb 2019',
      category: 'fruit'
  )
];
void main() {
  testWidgets("list renders correctly", (WidgetTester tester) async {
    final CardListWidget cardList = CardListWidget(
      key: listKey,
      cards: mockCards,
      onScroll: (double) {},
    );

    await tester.pumpWidget(WidgetWrapper.wrapWithMaterial(cardList));

    expect(find.byKey(listKey), findsOneWidget);

    expect(find.descendant(
      of: find.byType(CardFlipper),
      matching: find.byType(WordCardWidget)
    ), findsNWidgets(2));
  });

  testWidgets('scrolling card list with 2 cards', (WidgetTester tester) async {
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

    await tester.pumpWidget(WidgetWrapper.wrapWithMaterial(cardList));

    await tester.fling(find.byWidget(cardList), Offset(-800.0, 0.0), 150);

    await tester.pumpAndSettle(Duration(milliseconds: 100));

    expect(percent > 0.0, isTrue);

    expect(find.text('TEST'), findsNothing);

    expect(find.text('TEST2'), findsNWidgets(2));

  });

  testWidgets('scrolling card list with empty card list', (WidgetTester tester) async {
    double percent = 0.0;

    final CardListWidget cardList = CardListWidget(
      key: listKey,
      cards: [],
      onScroll: (double scrollPercent) {
        percent = scrollPercent;
      },
    );

    await tester.pumpWidget(WidgetWrapper.wrapWithMaterial(cardList));

    await tester.fling(find.byWidget(cardList), Offset(-800.0, 0.0), 150);

    await tester.pumpAndSettle(Duration(milliseconds: 100));

    expect(percent > 0.0, isFalse);

    expect(find.descendant(
        of: find.byType(CardFlipper),
        matching: find.byType(WordCardWidget)
    ), findsNothing);

  });
}