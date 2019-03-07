import 'package:flipflop/components/stackcard_widget.dart';
import 'package:flipflop/models/word_view_model.dart';
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

    await tester.pumpWidget(WidgetWrapper.wrapWithMaterial(stackCard));

    expect(find.byWidget(stackCard), findsOneWidget);

    expect(find.text("foo"), findsOneWidget);

  });
}