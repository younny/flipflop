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
class MockDatabaseExecutor extends Mock implements DatabaseExecutor {}
class MockDatabaseFactory extends Mock implements DatabaseFactory {}

void main() {
  LocalDB localDB;
  MockDatabaseExecutor mockDatabaseExecutor;
  MockDatabaseFactory factory;
  MockDatabase database;
  const MethodChannel channel = MethodChannel('com.tekartik.sqflite');
  final List<MethodCall> log = <MethodCall>[];
  Directory tempDir;
  setUpAll(() async {
    mockDatabaseExecutor = MockDatabaseExecutor();
    factory = MockDatabaseFactory();
    database = MockDatabase();
    localDB = LocalDB.instance;
    tempDir = await Directory.systemTemp.createTemp();

    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      String method = methodCall.method;
      log.add(methodCall);

      if(method == 'query') {
        await database.query(tableName);
        final List<Map<String, dynamic>> results = <Map<String, dynamic>>[
          <String, dynamic>{columnId: 1, columnWord: 'test 1'},
          <String, dynamic>{columnId: 2, columnWord: 'test 2'}
        ];
        return results;
      }

    });
  });

  tearDown(() {
    log.clear();
  });

  test("create database", () async {
    String dbName = 'test.db';
    String path = join(tempDir.path, dbName);

    await deleteDatabase(path);

    await localDB.open(path);

    expect(log.first.method, equals("openDatabase"));

    expect(log.first.arguments['path'], equals(path));

    expect(localDB.getPath(), equals(path));

    await localDB.close();
  });

  test("read database", () async {
    String dbName = 'test.db';
    String path = join(tempDir.path, dbName);

    await localDB.open(path);

    List<Map> results = await localDB.retrieveAll();

    expect(results.length, equals(2));

    expect(results.first.containsKey(columnId), isTrue);

    expect(log.last.method, equals("query"));

    expect(log.last.arguments['sql'], equals('SELECT * FROM $tableName'));

    await localDB.close();
  });

  test("insert data", () async {
    WordViewModel word = WordViewModel(
        id: 0,
        word: 'Test',
        meaning: 'This is test',
        lang: 'en',
        level: 0,
        category: 'foo',
        pronunciation: 'blah'
    );

    String dbName = 'test.db';
    String path = join(tempDir.path, dbName);

    await localDB.open(path);

    var results = await localDB.insert(word);

    expect(log.last.method, equals('insert'));

    expect(log.last.arguments['sql'].toString().startsWith('INSERT INTO $tableName'), isTrue);
  });


//  test("delete database", () async {
//
//  });
}