import 'package:flipflop/components/dropdown_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_wrapper.dart';

final String dialogTitle = "Test Dialog";
final String closeButtonText = "Close";
final String doneButtonText = "Done";
final List<String> items = ["item1", "item2", "item3"];
final Type dropdownButtonType = DropdownButton<int>(
  items: const <DropdownMenuItem<int>>[],
  onChanged: (index) {},
).runtimeType;
final Type dropdownMenuItemType = DropdownMenuItem<int>(
  child: Text(""),
).runtimeType;

Future<Widget> _buildDialog({
  WidgetTester tester,
  ValueChanged<int> onChange,
  ValueChanged<String> onDone
}) async {
  final dialog = DropdownDialog(
    items: items,
    onClose: () {},
    onDone: onDone,
    onChange: onChange,
    title: dialogTitle,
    closeText: closeButtonText,
    doneText: doneButtonText,
  );



  await tester.pumpWidget(wrap(dialog));
  return dialog;
}

void main() {
  testWidgets('renders dropdown view correctly', (WidgetTester tester) async {
      await _buildDialog(tester: tester, onChange: (index) {});

      expect(find.text(dialogTitle), findsOneWidget);
      expect(find.text(doneButtonText), findsOneWidget);
      expect(find.text(closeButtonText), findsOneWidget);
      
      expect(find.byType(dropdownButtonType), findsOneWidget);

      Finder f = find.descendant(
          of: find.byType(dropdownButtonType),
          matching: find.byType(dropdownMenuItemType)
      );

      expect(f, findsNWidgets(items.length));

      expect(find.byIcon(Icons.library_add), findsOneWidget);
  });

  testWidgets('select dropdown menu item', (WidgetTester tester) async {
    int value = 0;
    void onChange (index) {
      value = index;
    }

    await _buildDialog(tester: tester, onChange: onChange);
    State buttonState = tester.state(find.byType(dropdownButtonType));

    await tester.tap(find.text(items[0]));
    await tester.pumpAndSettle();

    expect(value, equals(0));
    expect((buttonState.widget as DropdownButton).value, equals(0));

    await tester.tap(find.text(items[1]).last);
    await tester.pumpAndSettle();

    expect(value, equals(1));
    expect((buttonState.widget as DropdownButton).value, equals(1));

    await tester.tap(find.text(items[1]));
    await tester.pumpAndSettle();

    expect(value, equals(1));

    await tester.tap(find.text(items[2]).last);
    await tester.pumpAndSettle();

    expect(value, equals(2));
    expect((buttonState.widget as DropdownButton).value, equals(2));

  });

  testWidgets('renders edit mode when add library icon clicked', (WidgetTester tester) async {
    await _buildDialog(tester: tester);

    Finder addIcon = find.byIcon(Icons.library_add);
    await tester.tap(addIcon);
    await tester.pumpAndSettle();

    expect(find.byType(Form), findsOneWidget);

    expect(find.text("New Folder 1"), findsOneWidget);
  });

  testWidgets('enter new folder name in edit mode', (WidgetTester tester) async {
    String result;
    void onDone(String value) {
      result = value;
    }
    await _buildDialog(tester: tester, onDone: onDone);

    Finder addIcon = find.byIcon(Icons.library_add);
    await tester.tap(addIcon);
    await tester.pumpAndSettle();

    Finder inputField = find.byType(TextFormField);
    expect(inputField, findsOneWidget);
    await tester.enterText(inputField, "New Folder 2");

    await tester.tap(find.text(doneButtonText));
    await tester.pumpAndSettle();

    expect(result, equals("New Folder 2"));

  });

  testWidgets('close dialog when done and close button clicked.', (WidgetTester tester) async {
    final dialog = DropdownDialog(
      items: items,
      title: dialogTitle,
      closeText: closeButtonText,
      doneText: doneButtonText,
    );

    final app = MaterialApp(
      home: Material(
        child: Builder(
          builder: (BuildContext context) {
            return Container(
              child: FlatButton(
                  onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return dialog;
                      }
                  ),
                  child: Text("click-this")
              ),
            );
          },
        )
      )
    );

    await tester.pumpWidget(app);
    await tester.tap(find.text("click-this"));
    await tester.pumpAndSettle();

    expect(find.byWidget(dialog), findsOneWidget);

    Finder addIcon = find.byIcon(Icons.library_add);
    await tester.tap(addIcon);
    await tester.pumpAndSettle();

    Finder inputField = find.byType(TextFormField);
    expect(inputField, findsOneWidget);

    await tester.tap(find.text(doneButtonText));
    await tester.pumpAndSettle();

    expect(inputField, findsNothing);
    expect(find.byWidget(dialog), findsNothing);

    await tester.tap(find.text("click-this"));
    await tester.pumpAndSettle();

    expect(find.byWidget(dialog), findsOneWidget);

    await tester.tap(find.text(closeButtonText));
    await tester.pumpAndSettle();

    expect(find.byWidget(dialog), findsNothing);
  });

}