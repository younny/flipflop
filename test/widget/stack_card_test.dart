import 'package:flipflop/models/korean.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/widgets/stackcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_wrapper.dart';

void main() {
  testWidgets("Stack card renders correctly", (WidgetTester tester) async {
    final stackCard = StackCardWidget(
        card: Korean(
            word: "foo",
            meaning: "Test"
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
    WordViewModel wordViewModel;

    final stackCard = StackCardWidget(
        card: Korean(
            word: "foo",
            meaning: "Test"
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
      card: Korean(
          word: "foo",
          meaning: "Test"
      ),
      onLongPress: null
    );

    await tester.pumpWidget(wrap(stackCard));

    await tester.longPress(find.byWidget(stackCard));
  });

  testWidgets("select mode changed when long pressed", (WidgetTester tester) async {

    bool parentSelectionModeOn = false;
    WordViewModel selectedWord;
    final stackCard = StackCardWidget(
        card: Korean(
            word: "foo",
            meaning: "Test"
        ),
        onLongPress: (card) {
          parentSelectionModeOn = true;
        },
        onPress: (word) {
          selectedWord = word;
        },
        selectMode: parentSelectionModeOn
    );

    await tester.pumpWidget(wrap(stackCard));

    await tester.longPress(find.byWidget(stackCard));
    expect(parentSelectionModeOn, isTrue);

    await tester.tap(find.byWidget(stackCard));
    expect(parentSelectionModeOn, isTrue);

    expect(selectedWord.word, equals("foo"));
    await tester.pump();
  });

  testWidgets("color changed correctly when parent selection mode is on", (WidgetTester tester) async {

    final stackCard = StackCardWidget(
        card: Korean(
            word: "foo",
            meaning: "Test"
        ),
        onLongPress: (_) {
        },
        onPress: (_) {
        },
        selectMode: true
    );
    await tester.pumpWidget(wrap(stackCard));

    StatefulElement element = tester.element(find.byWidget(stackCard));
    StackCardWidgetState state = element.state;

    RaisedButton button = tester.widget(find.byType(RaisedButton));

    await tester.tap(find.byWidget(button));
    expect(state.selected, isTrue);
    expect(state.color, Colors.amberAccent);

    await tester.tap(find.byWidget(button));
    expect(state.selected, isFalse);
    expect(state.color, Colors.amber.withOpacity(0.5));

  });

}