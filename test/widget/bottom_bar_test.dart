import 'package:flipflop/components/bottom_bar.dart';
import 'package:flipflop/components/scroll_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_wrapper.dart';

Future<void> _buildBottomBarWidget(WidgetTester tester) async {
  final bottomBar = BottomBar(
      numOfSteps: 10,
      scrollPercent: 0
  );
  final container = Container(
    child: bottomBar,
  );
  await tester.pumpWidget(wrap(container));
}

void main() {

  testWidgets('bottom bar renders correctly', (WidgetTester tester) async {
    await _buildBottomBarWidget(tester);

    expect(find.byType(Icon), findsNWidgets(2));

    expect(find.byType(ScrollIndicator), findsOneWidget);
  });

  testWidgets('add button shows add dialog alert', (WidgetTester tester) async {
    await _buildBottomBarWidget(tester);

    Finder addIconButton = find.byTooltip("add to my stack");

    expect(addIconButton, findsOneWidget);

    await tester.tap(addIconButton);

    await tester.pumpAndSettle();

    Finder alert = find.byType(AlertDialog);

    expect(alert, findsOneWidget);
  });

}