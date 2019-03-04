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

}