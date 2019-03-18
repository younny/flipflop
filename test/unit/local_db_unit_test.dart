import 'dart:io';

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
  MockDatabase database;
  Directory tempDir;
  const MethodChannel channel = MethodChannel('com.tekartik.sqflite');
  final List<MethodCall> log = <MethodCall>[];
  setUpAll(() async {
    database = MockDatabase();
    localDB = LocalDB.instance;
    tempDir = await Directory.systemTemp.createTemp();

    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      String method = methodCall.method;
      log.add(methodCall);
      if(method == 'getDatabasesPath') {
        return tempDir.path;
      }
      if(method == 'query') {
        await database.query(tableName);
        final List<Map<String, dynamic>> results = <Map<String, dynamic>>[
          <String, dynamic>{columnId: 1, columnWord: 'test 1'},
          <String, dynamic>{columnId: 2, columnWord: 'test 2'}
        ];
        return results;
      }

      if(method == 'update') {
        return 0;
      }

    });
  });

  tearDown(() async {
    log.clear();
  });

  test("create database", () async {
    String dbName = 'test';

    await localDB.open(dbName);

    expect(log[0].method, equals("getDatabasesPath"));

    expect(log[1].method, equals("openDatabase"));

    expect(log.last.method, equals("execute"));
  });

  test("read database", () async {
    String dbName = 'test';

    await localDB.open(dbName);

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

    String dbName = 'test';

    await localDB.open(dbName);

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

    await localDB.open('test');

    int row = await localDB.delete(id);

    expect(row, equals(0));

    expect(log.last.method, equals('update'));

    expect(log.last.arguments['sql'].toString().startsWith('DELETE FROM'), isTrue);
  });
}