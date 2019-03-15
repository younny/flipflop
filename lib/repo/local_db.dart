import 'package:flipflop/models/db_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:sqflite/sqflite.dart';

class LocalDB {
  Database _db;

  static final LocalDB _instance = LocalDB._internal();

  static get instance => _instance;

  LocalDB._internal();

  Future setDebug() async {
    await Sqflite.setDebugModeOn();
  }

  Future<String> getPath() async {
    return await getDatabasesPath();
  }

  Future open(String path) async {
    _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          print("Create db : $path");
          return create(db, version);
        });
  }

  bool isOpened() {
    return _db.isOpen;
  }

  Future<int> getVersion() async {
    return await _db.getVersion();
  }

  Future create(Database db, int version) async {
    await db.execute('''
      create table $tableName (
      $columnId integer primary key autoincrement,
      $columnWord text not null,
      $columnMeaning text not null,
      $columnPron text not null,
      $columnLang text not null,
      $columnCategory text not null,
      $columnLevel integer not null)
      ''');
  }

  Future<int> insert(WordViewModel item) async {
    int result = await _db.insert(tableName, item.toMap());
    return result;
  }
  
  Future<WordViewModel> retrieve(int id) async {
    List<Map> maps = await _db.query(tableName,
    columns: [columnId, columnWord],
    where: '$columnId = ?',
    whereArgs: [id]) ?? List<Map<String, dynamic>>();

    if(maps.length > 0)
      return WordViewModel.fromJson(maps.first);

    return null;
  }

  Future<List<Map>> retrieveAll() async {
    List<Map> maps = await _db.query(tableName) ?? [];
    return maps;
  }

  Future<int> delete(int id) async {
    return await _db.delete(tableName,
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(WordViewModel item) async {
    return await _db.update(tableName, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }

  Future close() async {
    await _db.close();
  }
}