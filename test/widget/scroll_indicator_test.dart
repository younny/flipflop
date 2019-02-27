import 'dart:ui';

import 'package:flip/components/scroll_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_wrapper.dart';

void main() {
  testWidgets('scroll indicator renders correctly', (WidgetTester tester) async {
    final scrollIndicator = ScrollIndicator(
      numOfSteps: 10,
      scrollPercent: 0
    );
    await tester.pumpWidget(WidgetWrapper.wrapWithMaterial(scrollIndicator));

    expect(find.byType(ScrollIndicator), findsOneWidget);

    expect(find.descendant(
      of: find.byType(ScrollIndicator),
      matching: find.byType(CustomPaint)
    ), findsOneWidget);
//
//    expect(find.descendant(
//        of: find.byType(ScrollIndicator),
//        matching: find.byType(CustomPaint)
//    ), findsOneWidget);

    //expect(find.byType(RRect), findsNWidgets(2));
  });

  testWidgets('scroll indicator painter renders correctly', (WidgetTester tester) async {

  });

  testWidgets('increase scroll percent periodically', (WidgetTester tester) async {
//    double scrollPercent = 0.0;
//
//    final scrollIndicator = ScrollIndicator(
//        numOfSteps: 10,
//        scrollPercent: scrollPercent
//    );
//    await tester.pumpWidget(WidgetWrapper.wrapWithMaterial(scrollIndicator));


//    expect(tester.getRect(find.byType(RRect)).left,
//    expect(find.byType(ScrollIndicator), findsOneWidget);
  });

}