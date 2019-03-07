import 'package:flipflop/components/scroll_indicator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flipflop/components/bottom_bar.dart';

import '../helper/widget_wrapper.dart';

void main() {
  testWidgets('bottom bar renders correctly', (WidgetTester tester) async {
    final bottomBar = BottomBar(
      numOfSteps: 10,
      scrollPercent: 0
    );

    await tester.pumpWidget(WidgetWrapper.wrapWithMaterial(bottomBar));

    expect(find.byType(Icon), findsNWidgets(2));

    expect(find.byType(ScrollIndicator), findsOneWidget);
  });

  testWidgets('add button shows add dialog alert', (WidgetTester tester) async {
    final bottomBar = BottomBar(
        numOfSteps: 10,
        scrollPercent: 0
    );
    final container = Container(
      child: bottomBar,
    );

    await tester.pumpWidget(WidgetWrapper.wrapWithMaterial(container));

    Finder addIconButton = find.byTooltip("add to my stack");

    expect(addIconButton, findsOneWidget);

    await tester.tap(addIconButton);

    await tester.pumpAndSettle();

    Finder alert = find.byType(AlertDialog);

    expect(alert, findsOneWidget);

    await tester.tap(find.text("Done"));

    await tester.pumpAndSettle();

  });

}