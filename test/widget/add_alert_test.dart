import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('add dialog renders correctly', (WidgetTester tester) async {
    Finder alert = find.byType(AlertDialog);

    expect(alert, findsOneWidget);
  });

  testWidgets('close dialog when done button clicked.', (WidgetTester tester) async {

    Finder alert = find.byType(AlertDialog);

    expect(alert, findsOneWidget);

    await tester.tap(find.text("Done"));

    await tester.pumpAndSettle();

    expect(alert, findsNothing);

  });

  testWidgets('close dialog when cancel button clicked.', (WidgetTester tester) async {

    Finder alert = find.byType(AlertDialog);

    expect(alert, findsOneWidget);

    await tester.tap(find.text("Cancel"));

    await tester.pumpAndSettle(Duration(microseconds: 150));

    expect(alert, findsNothing);

  });
}