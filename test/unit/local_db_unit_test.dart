import 'dart:io';

import 'package:flipflop/constant/error.dart';
import 'package:flipflop/exception.dart';
import 'package:flipflop/models/db_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/local_db.dart';
import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' hide equals;
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  LocalDB localDB;
  MockDatabase mockDatabase;
  Directory tempDir;
  const MethodChannel channel = MethodChannel('com.tekartik.sqflite');
  final List<MethodCall> log = <MethodCall>[];

  group("database path exception", () {
    setUp(() async {
      mockDatabase = MockDatabase();
      localDB = LocalDB.instance;
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        String method = methodCall.method;
        if(method == 'getDatabasesPath') {
          throw Error();
        }
      });
    });

    test("get path", () async {
      expect(() async => await localDB.getPath(),
          throwsA(TypeMatcher<LocalDatabaseException>()
              .having((e) => e.message, "message", contains(FFError.LOCAL_DATABASE))));
    });
  });

  group("normal test", () {
    setUp(() async {
      mockDatabase = MockDatabase();
      localDB = LocalDB.instance;
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        String method = methodCall.method;
        log.add(methodCall);
        if(method == 'getDatabasesPath') {
          tempDir = await Directory.systemTemp.createTemp();
          return tempDir.path;
        }
        if(method == 'query') {
          await mockDatabase.query(tableName);
          final List<Map<String, dynamic>> results = <Map<String, dynamic>>[
            <String, dynamic>{columnId: 1, columnWord: 'test 1'},
            <String, dynamic>{columnId: 2, columnWord: 'test 2'}
          ];
          return results;
        }

        if(method == 'update') {
          if(localDB.isOpened()) return 0;
          throw Exception("attempt to re-open an already-closed object");
        }

      });
    });

    tearDown(() async {
      log.clear();
    });

    test("create database", () async {
      await localDB.open();

      expect(log[0].method, equals("getDatabasesPath"));

      expect(log[1].method, equals("openDatabase"));

      expect(log.last.method, equals("execute"));
    });

    test("read database", () async {
      await localDB.open();

      List<Map> results = await localDB.retrieveAll();

      expect(results.length, equals(2));

      expect(results.first.containsKey(columnId), isTrue);

      expect(log.last.method, equals("query"));

      expect(log.last.arguments['sql'], equals('SELECT * FROM $tableName'));
    });

    test("insert data", () async {
      WordViewModel word = WordViewModel(
          id: "1234567",
          word: 'Test',
          meaning: 'This is test',
          lang: 'en',
          level: 0,
          category: 'foo',
          pronunciation: 'blah'
      );

      await localDB.open();

      await localDB.insert(word);

      expect(log.last.method, equals('insert'));

      expect(log.last.arguments['sql'].toString().startsWith('INSERT INTO $tableName'), isTrue);
    });

    test("set database path correctly", () async {
      String path = await localDB.getPath();

      expect(path, equals(tempDir.path));

      String name = 'test1';
      String fullPath = await localDB.getFullPath(name);

      expect(fullPath, equals(join(tempDir.path, name)));
    });

    test("delete database", () async {
      String id = 'test';

      await localDB.open();

      int row = await localDB.delete(id);

      expect(row, equals(0));

      expect(log.last.method, equals('update'));

      expect(log.last.arguments['sql'].toString().startsWith('DELETE FROM'), isTrue);
    });

    test("access database after closed", () async {
      await localDB.close();

      print(localDB.isOpened());
      String id = 'test';

      expect(() async => await localDB.delete(id),
          throwsA(TypeMatcher<LocalDatabaseException>()
              .having((e) => e.message, "message", contains("attempt to re-open an already-closed object"))));
    });
  });

  group("other exceptions", () {
    WordViewModel word = WordViewModel(
        id: "1234567",
        word: 'Test',
        meaning: 'This is test',
        lang: 'en',
        level: 0,
        category: 'foo',
        pronunciation: 'blah'
    );
    String id = 'test';

    setUp(() async {
      mockDatabase = MockDatabase();
      localDB = LocalDB.instance;
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        String method = methodCall.method;
        if(method == 'getDatabasesPath') {
          tempDir = await Directory.systemTemp.createTemp();
          return tempDir.path;
        }
        if(method == 'query') {
          await mockDatabase.query(tableName);
          return null;
        }

        if(method == 'insert') {
          await mockDatabase.insert(tableName, word.toMap());
        }

        if(method == 'update') {
          await mockDatabase.delete(id);
          return null;
        }
      });
    });

    tearDown(() async {
    });

    test("read database", () async {
      await localDB.open();

      when(mockDatabase.query(tableName)).thenThrow(Error());

      expect(() async => await localDB.retrieveAll(),
        throwsA(TypeMatcher<LocalDatabaseException>()
        .having((e) => e.message, "message", contains(FFError.LOCAL_DATABASE))));
    });

    test("insert data", () async {
      WordViewModel word = WordViewModel(
          id: "1234567",
          word: 'Test',
          meaning: 'This is test',
          lang: 'en',
          level: 0,
          category: 'foo',
          pronunciation: 'blah'
      );

      await localDB.open();

      when(mockDatabase.insert(tableName, word.toMap())).thenThrow(Error());

      expect(() async => await localDB.insert(word),
          throwsA(TypeMatcher<LocalDatabaseException>()
              .having((e) => e.message, 'message', contains(FFError.LOCAL_DATABASE))));
    });

    test("insert data which is already exsists", () async {
      WordViewModel word = WordViewModel(
          id: "1234567",
          word: 'Test',
          meaning: 'This is test',
          lang: 'en',
          level: 0,
          category: 'foo',
          pronunciation: 'blah'
      );

      await localDB.open();

      await localDB.insert(word);

      when(mockDatabase.insert(tableName, word.toMap()))
          .thenThrow(Exception("UNIQUE constraint failed"));

      expect(() async => await localDB.insert(word),
          throwsA(TypeMatcher<LocalDatabaseException>()
              .having((e) => e.message, 'message', contains("UNIQUE constraint failed"))));

    });

    test("delete database", () async {
      String id = 'test';

      await localDB.open();

      when(mockDatabase.delete(id)).thenThrow(Error());

      expect(() async => await localDB.delete(id),
          throwsA(TypeMatcher<LocalDatabaseException>()
              .having((e) => e.message, 'message', contains(FFError.LOCAL_DATABASE))));
    });

  });

}