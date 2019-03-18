import 'package:flipflop/widgets/bottom_bar.dart';
import 'package:flipflop/widgets/scroll_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_wrapper.dart';

Future<void> _buildBottomBarWidget(WidgetTester tester) async {
  final bottomBar = BottomBar(
    numOfSteps: 10,
    scrollPercent: 0,
    onLeftIconPress: () {},
    onRightIconPress: () {},
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

  testWidgets('click left button, right button', (WidgetTester tester) async {
    bool leftPressed = false;
    bool rightPressed = false;
    final bottomBar = BottomBar(
      numOfSteps: 10,
      scrollPercent: 0,
      onLeftIconPress: () {
        rightPressed = true;
      },
      onRightIconPress: () {
        leftPressed = true;
      },
    );
    final container = Container(
      child: bottomBar,
    );
    await tester.pumpWidget(wrap(container));

    Finder addIconButton = find.byTooltip("add to my stack");
    expect(addIconButton, findsOneWidget);

    await tester.tap(addIconButton);
    expect(leftPressed, isTrue);

    Finder settingsButton = find.byIcon(Icons.settings);
    expect(addIconButton, findsOneWidget);

    await tester.tap(settingsButton);
    expect(rightPressed, isTrue);

  });

}