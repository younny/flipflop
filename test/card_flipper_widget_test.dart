import 'package:flip/components/wordcard_widget.dart';
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
  testWidgets('Card flipper renders correctly', (WidgetTester tester) async {
    final Key flipperKey = Key('card-flipper');

    const String mockMeaning = 'this is test';

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

    final CardFlipper cardFlipper = CardFlipper(
      key: flipperKey,
      cards: cards,
      onScroll: (double scrollPercent) {
      },
    );

    await tester.pumpWidget(wrapWithMaterial(cardFlipper));

    expect(find.text('TEST'), findsOneWidget);

  });

  testWidgets('Card flipper drag and tap interaction', (WidgetTester tester) async {
    final Key flipperKey = Key('card-flipper');

    double percent = 0.0;
    const String mockMeaning = 'this is test';

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

    final CardFlipper cardFlipper = CardFlipper(
      key: flipperKey,
      cards: cards,
      onScroll: (double scrollPercent) {
        percent = scrollPercent;
      },
    );

    await tester.pumpWidget(wrapWithMaterial(cardFlipper));

    await tester.tap(find.byKey(flipperKey));

//    expect(find.text(' $mockMeaning'), findsOneWidget);

    await tester.drag(find.byWidget(cardFlipper), Offset(-300.0, 0.0));

    expect(percent > 0.0, isTrue);

    expect(find.text('TEST2'), findsOneWidget);
  });
}