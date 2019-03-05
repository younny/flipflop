abstract class Database<T> {
  Future<T> create();

  Future<T> read(String table);

  Future<T> readByFilter(String table, String filter);

  Future<T> update();

  Future<T> delete();
}