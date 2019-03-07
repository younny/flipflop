import 'package:flipflop/components/scroll_indicator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flipflop/components/bottom_bar.dart';

import '../helper/widget_wrapper.dart';

void main() {
  testWidgets('add dialog renders correctly', (WidgetTester tester) async {
    final bottomBar = BottomBar(
        numOfSteps: 10,
        scrollPercent: 0
    );

    await tester.pumpWidget(WidgetWrapper.wrapWithMaterial(bottomBar));

    expect(find.byType(Icon), findsNWidgets(2));

    expect(find.byType(ScrollIndicator), findsOneWidget);
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