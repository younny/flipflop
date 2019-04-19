import 'package:flipflop/fixtures/mock_data.dart';
import 'package:flipflop/models/korean.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/widgets/card_flipper.dart';
import 'package:flipflop/widgets/card_list.dart';
import 'package:flipflop/widgets/wordcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_wrapper.dart';

final Key listKey = Key("card-list");

void main() {
  testWidgets("list renders correctly", (WidgetTester tester) async {
    final CardListWidget cardList = CardListWidget(
      key: listKey,
      cards: mockCards,
      onScroll: (double) {},
    );

    await tester.pumpWidget(wrap(cardList));

    expect(find.byKey(listKey), findsOneWidget);

    expect(find.descendant(
      of: find.byType(CardFlipper),
      matching: find.byType(WordCardWidget)
    ), findsNWidgets(2));
  });

  testWidgets('scrolling card list with 2 cards', (WidgetTester tester) async {
    double percent = 0.0;

    final List<WordViewModel> cards = [
      Korean(
          word: 'TEST'
      ),
      Korean(
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

    await tester.pumpWidget(wrap(cardList));

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

    await tester.pumpWidget(wrap(cardList));

    await tester.fling(find.byWidget(cardList), Offset(-800.0, 0.0), 150);

    await tester.pumpAndSettle(Duration(milliseconds: 100));

    expect(percent > 0.0, isFalse);

    expect(find.descendant(
        of: find.byType(CardFlipper),
        matching: find.byType(WordCardWidget)
    ), findsNothing);

  });
}