import 'package:flipflop/widgets/dropdown_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_wrapper.dart';

final String dialogTitle = "Test Dialog";
final String closeButtonText = "Close";
final String doneButtonText = "Done";
final List<String> mockItems = ["item1", "item2", "item3"];
final Type dropdownButtonType = DropdownButton<String>(
  items: const <DropdownMenuItem<String>>[],
  onChanged: (index) {},
).runtimeType;
final Type dropdownMenuItemType = DropdownMenuItem<String>(
  child: Text(""),
).runtimeType;

Future<Widget> _buildDialog<T>({
  WidgetTester tester,
  List<T> items,
  ValueChanged onChange,
  ValueChanged onDone,
  VoidCallback onClose,
  T value,
  bool supportEditMode = false
}) async {
  final dialog = DropdownDialog<T>(
    items: items ?? mockItems,
    value: value,
    onClose: onClose,
    onDone: onDone,
    onChange: onChange,
    title: dialogTitle,
    closeText: closeButtonText,
    doneText: doneButtonText,
    supportEditMode: supportEditMode,
  );

  await tester.pumpWidget(wrap(dialog));
  return dialog;
}

void main() {
  testWidgets('renders dropdown view correctly', (WidgetTester tester) async {
      await _buildDialog<String>(
          tester: tester,
          onChange: (index) {}
      );


      expect(find.text(dialogTitle), findsOneWidget);
      expect(find.text(doneButtonText), findsOneWidget);
      expect(find.text(closeButtonText), findsOneWidget);
      
      expect(find.byType(dropdownButtonType), findsOneWidget);

      Finder f = find.descendant(
          of: find.byType(dropdownButtonType),
          matching: find.byType(dropdownMenuItemType)
      );

      expect(f, findsNWidgets(mockItems.length));
  });

  testWidgets('dropdown has default value', (WidgetTester tester) async {
    String defaultOption;

    await _buildDialog<String>(
        tester: tester,
        value: mockItems[0],
        onDone: (selected) {
         defaultOption = selected;
        });

    await tester.tap(find.text(doneButtonText));
    await tester.pumpAndSettle();

    expect(defaultOption, equals(mockItems[0]));

  });

  testWidgets('when items list empty, show no item', (WidgetTester tester) async {
    await _buildDialog<String>(tester: tester, items: []);
    State buttonState = tester.state(find.byType(dropdownButtonType));

    expect((buttonState.widget as DropdownButton).value, isNull);
  });

  testWidgets('when items list null, show no item', (WidgetTester tester) async {
    await _buildDialog<String>(tester: tester, items: null);
    State buttonState = tester.state(find.byType(dropdownButtonType));

    expect((buttonState.widget as DropdownButton).value, isNull);
  });

  testWidgets('select dropdown menu item', (WidgetTester tester) async {
    String item = mockItems[0];
    void onChange (newItem) {
      item = newItem;
    }

    await _buildDialog<String>(tester: tester, onChange: onChange, value: mockItems[0]);
    State buttonState = tester.state(find.byType(dropdownButtonType));

    await tester.tap(find.text(mockItems[0]));
    await tester.pumpAndSettle();

    expect(item, mockItems[0]);
    expect((buttonState.widget as DropdownButton).value, equals(mockItems[0]));

    await tester.tap(find.text(mockItems[1]).last);
    await tester.pumpAndSettle();

    expect(item, mockItems[1]);
    expect((buttonState.widget as DropdownButton).value, equals(mockItems[1]));

    await tester.tap(find.text(mockItems[1]));
    await tester.pumpAndSettle();

    expect(item, mockItems[1]);

    await tester.tap(find.text(mockItems[2]).last);
    await tester.pumpAndSettle();

    expect(item, mockItems[2]);
    expect((buttonState.widget as DropdownButton).value, equals(mockItems[2]));

  });

//  testWidgets('renders edit mode when add library icon clicked', (WidgetTester tester) async {
//    await _buildDialog<String>(tester: tester);
//
//    Finder addIcon = find.byIcon(Icons.library_add);
//    await tester.tap(addIcon);
//    await tester.pumpAndSettle();
//
//    expect(find.byType(Form), findsOneWidget);
//
//    expect(find.text("New Folder 1"), findsOneWidget);
//  });

  testWidgets('do not render add icon when it doesn\'t support edit mode', (WidgetTester tester) async {
    await _buildDialog<String>(tester: tester, supportEditMode: false);

    Finder addIcon = find.byIcon(Icons.library_add);

    expect(addIcon, findsNothing);
  });

//  testWidgets('enter new folder name and click done', (WidgetTester tester) async {
//    String result;
//    void onDone(value) {
//      result = value;
//    }
//    await _buildDialog<String>(tester: tester, onDone: onDone);
//
//    Finder addIcon = find.byIcon(Icons.library_add);
//    await tester.tap(addIcon);
//    await tester.pumpAndSettle();
//
//    Finder inputField = find.byType(TextFormField);
//    expect(inputField, findsOneWidget);
//    await tester.enterText(inputField, "New Folder 2");
//
//    await tester.tap(find.text(doneButtonText));
//    await tester.pumpAndSettle();
//
//    expect(result, equals("New Folder 2"));
//  });

//  testWidgets('enter new folder but cancel and exit should return default', (WidgetTester tester) async {
//    bool closed = false;
//    String defaultOption;
//    void onClose() {
//      closed = true;
//    }
//    await _buildDialog<String>(tester: tester, onClose: onClose, onDone: (selected) {
//      defaultOption = selected;
//    });
//
//    State buttonState = tester.state(find.byType(dropdownButtonType));
//    expect((buttonState.widget as DropdownButton).items.length, equals(mockItems.length));
//
//    Finder addIcon = find.byIcon(Icons.library_add);
//    await tester.tap(addIcon);
//    await tester.pumpAndSettle();
//
//    Finder inputField = find.byType(TextFormField);
//    expect(inputField, findsOneWidget);
//    await tester.enterText(inputField, "New Folder 2");
//
//    await tester.tap(find.byType(FlatButton).last);
//    await tester.pumpAndSettle();
//
//    expect(closed, isFalse);
//    expect(inputField, findsNothing);
//    expect((buttonState.widget as DropdownButton).items.length, equals(mockItems.length));
//
//    await tester.tap(find.text(doneButtonText));
//    await tester.pumpAndSettle();
//
//    expect(defaultOption, equals(mockItems[0]));
//
//  });

//  testWidgets('change initial index after item was selected', (WidgetTester tester) async {
//    bool closed = false;
//    int selectedIndex = 0;
//    String selectedItem = mockItems[0];
//
//    var dialog = await _buildDialog(
//        tester: tester,
//        onDone: (selected) {
//          print(selected);
//          selectedItem = selected;
//          closed = true;
//        },
//        onChange: (index) {
//          selectedIndex = index;
//        },
//        initialIndex: selectedIndex
//    );
//
//    State buttonState = tester.state(find.byType(dropdownButtonType));
//    expect((buttonState.widget as DropdownButton).items.length, equals(mockItems.length));
//
//    await tester.tap(find.text(mockItems[0]));
//    await tester.pumpAndSettle();
////    await tester.tap(find.text(mockItems[1]).last);
////    await tester.pumpAndSettle();
////
////    expect(selectedIndex, equals(1));
////    expect((buttonState.widget as DropdownButton).value, equals(1));
//
//    await tester.tap(find.text(mockItems[1]).last);
//    await tester.pumpAndSettle();
//
//    expect(selectedIndex, equals(1));
//    expect((buttonState.widget as DropdownButton).value, equals(1));
//
//    await tester.tap(find.text(doneButtonText));
//    await tester.pumpAndSettle();
//
//    expect(closed, isTrue);
//    expect((dialog as DropdownDialog).initialIndex, selectedIndex);
//
//  });

  testWidgets('close dialog when done and close button clicked.', (WidgetTester tester) async {
    final dialog = DropdownDialog(
      items: mockItems,
      title: dialogTitle,
      closeText: closeButtonText,
      doneText: doneButtonText,
    );

    Widget inject (BuildContext context) {
      return FlatButton(
          onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return dialog;
              }
          ),
          child: Text("click-this")
      );
    }

    await tester.pumpWidget(wrapWithContext(inject));
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