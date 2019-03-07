import 'package:flipflop/components/stackcard_widget.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_wrapper.dart';

void main() {
  testWidgets("Stack card renders correctly", (WidgetTester tester) async {

    DateTime dateTime = DateTime.now();
    final stackCard = StackCardWidget(
        card: WordViewModel(
            word: "foo",
            meaning: "Test",
            pronunciation: "Blah",
            created: dateTime,
            level: 0,
            category: "test",
            lang: "en"
        )
    );

    await tester.pumpWidget(wrap(stackCard));

    expect(find.byWidget(stackCard), findsOneWidget);

    expect(find.text("foo"), findsOneWidget);

    final RaisedButton button = tester.widget(find.byType(RaisedButton));
    expect(button.color, equals(Colors.amber));

  });

  testWidgets("Sends callback when long pressed", (WidgetTester tester) async {

    bool longPressed = false;
    WordViewModel wordViewModel = null;

    final stackCard = StackCardWidget(
        card: WordViewModel(
            word: "foo",
            meaning: "Test",
            pronunciation: "Blah",
            created: DateTime.now(),
            level: 0,
            category: "test",
            lang: "en"
        ),
        onLongPress: (card) {
          longPressed = true;
          wordViewModel = card;
        },
    );

    await tester.pumpWidget(wrap(stackCard));

    await tester.longPress(find.byWidget(stackCard));

    expect(longPressed, isTrue);

    expect(wordViewModel, isNotNull);

    expect(wordViewModel.word, equals("foo"));

  });

  testWidgets("passes null to onLongPress", (WidgetTester tester) async {

    final stackCard = StackCardWidget(
      card: WordViewModel(
          word: "foo",
          meaning: "Test",
          pronunciation: "Blah",
          created: DateTime.now(),
          level: 0,
          category: "test",
          lang: "en"
      ),
      onLongPress: null
    );

    await tester.pumpWidget(wrap(stackCard));

    await tester.longPress(find.byWidget(stackCard));
  });

  testWidgets("select mode changed when long pressed", (WidgetTester tester) async {

    bool parentSelectionModeOn = false;
    final stackCard = StackCardWidget(
        card: WordViewModel(
            word: "foo",
            meaning: "Test",
            pronunciation: "Blah",
            created: DateTime.now(),
            level: 0,
            category: "test",
            lang: "en"
        ),
        onLongPress: (card) {
          parentSelectionModeOn = true;
        },
        selectMode: parentSelectionModeOn
    );

    await tester.pumpWidget(wrap(stackCard));

    final RaisedButton button = tester.widget(find.byType(RaisedButton));
    expect(button.color, equals(Colors.amber));

    await tester.longPress(find.byWidget(stackCard));
    expect(parentSelectionModeOn, isTrue);
    await tester.pump();
    expect(button.color, equals(Colors.amber.withOpacity(0.4)));

    await tester.tap(find.byWidget(stackCard));
    expect(parentSelectionModeOn, isTrue);
    await tester.pump();
    expect(button.color, equals(Colors.amber));

  });

}