import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('FlipFlop - HomePage', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if(driver != null) {
        driver.close();
      }
    });

    test('renders home page', () async {
      expect(await driver.getText(find.text('Home')), isNotNull);

    });

    test('scroll categories view', () async {

      Timeline timeline = await driver.traceAction(() async {

        SerializableFinder list = find.byType('CustomScrollView');

        await driver.scroll(list, 0, -500.0, Duration(milliseconds: 100));

        await driver.scroll(list, 0, 500.0, Duration(milliseconds: 100));

      });

      TimelineSummary summary = TimelineSummary.summarize(timeline);

      summary.writeSummaryToFile('scrolling_performance', pretty: true);

      summary.writeTimelineToFile('scrolling_performance', pretty: true);

    });

    test('navigate to game screen by clicking a category', () async {

      await driver.tap(find.byValueKey('cat-0'));

      expect(find.byType('CircularProgressIndicator'), isNotNull);

      await Future<void>.delayed(Duration(seconds: 1));

      expect(find.byType('CardListWidget'), isNotNull);
    });

    test('flip card', () async {
      SerializableFinder card = find.byType('WordCardWidget');

      await driver.tap(card); //flip, shows meaning

      await Future<void>.delayed(Duration(milliseconds: 100));

      await driver.tap(card); //flip, shows meaning
    });

    test('swipe to next card', () async {
      SerializableFinder cardsList = find.byType('CardListWidget');

      for(int i = 0; i<10; i++) {
        await driver.scroll(cardsList, -300, 0, Duration(milliseconds: 100));
      }

    });

    test('add 2 cards to stack', () async {
      SerializableFinder cardsList = find.byType('CardListWidget');
      SerializableFinder addIcon = find.byTooltip('add to my stack');
      await driver.tap(addIcon);

      await Future<void>.delayed(Duration(milliseconds: 500));

      await driver.scroll(cardsList, 300, 0, Duration(milliseconds: 100));

      await driver.tap(addIcon);

      await Future<void>.delayed(Duration(milliseconds: 500));
    });

    test('navigate back to home page', () async {
      await driver.tap(find.pageBack());

      expect(find.text('Home'), isNotNull);
    });

    test('navigate to my stack page', () async {
      await driver.tap(find.byTooltip('My Stack'));

      expect(find.text('My Stack'), isNotNull);

      expect(find.byType('GridView'), isNotNull);
    });

    test('start game view from play icon', () async {
      await driver.tap(find.byTooltip('Play'));

      await Future<void>.delayed(Duration(milliseconds: 100));

      expect(find.byType('CardListWidget'), isNotNull);
    });

    test('navigate back to my stack page', () async {
      await driver.tap(find.pageBack());

      expect(find.text('My Stack'), isNotNull);

      expect(find.byType('GridView'), isNotNull);

    });

//    test('delete one of stack items', () async {
//
//    });
    test('navigate to settings page', () async {
      await driver.tap(find.pageBack());

      expect(find.text('Home'), isNotNull);

      await driver.tap(find.byTooltip('Settings'));

      expect(find.byType('SettingsItemRow'), isNotNull);

      await Future<void>.delayed(Duration(milliseconds: 1000));
    });

    test('change language', () async {
      SerializableFinder settingsItem = find.text('Change Language to learn');

      await driver.tap(settingsItem);

      expect(find.text('Korean'), isNotNull);

      await driver.tap(find.text('Korean'));

      await Future<void>.delayed(Duration(milliseconds: 300));

      await driver.tap(find.text('German'));

      await driver.tap(find.text('Done'));
    });

    test('change level', () async {
      SerializableFinder settingsItem = find.text('Set Level');

      await driver.tap(settingsItem);

      expect(find.text('0'), isNotNull);

      await driver.tap(find.text('0'));

      await Future<void>.delayed(Duration(milliseconds: 300));

      await driver.tap(find.text('2'));

      await driver.tap(find.text('Done'));
    });

    test('navigate back to home page', () async {
      await driver.tap(find.pageBack());

      expect(find.text('Home'), isNotNull);

      await Future<void>.delayed(Duration(milliseconds: 3000));

    });
  });
}