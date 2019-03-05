import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/repo/base_db.dart';

class FirebaseDB extends Database<List<DocumentSnapshot>> {
  final Firestore _firestore;

  static final FirebaseDB _instance = FirebaseDB._internal(Firestore.instance);

  static FirebaseDB get instance => _instance;

  FirebaseDB._internal(this._firestore);

  @override
  Future<List<DocumentSnapshot>> create() {
    // TODO: implement create
    return null;
  }

  @override
  Future<List<DocumentSnapshot>> delete() {
    // TODO: implement delete
    return null;
  }

  @override
  Future<List<DocumentSnapshot>> read(String table) async {
    return await _firestore
            .collection(table)
            .snapshots()
            .first
            .then((QuerySnapshot snapshot) => snapshot.documents)
            .catchError((error) {
              print("Error while reading firestore db, $error");
            });
  }

  @override
  Future<List<DocumentSnapshot>> update() {
    // TODO: implement update
    return null;
  }

  @override
  Future<List<DocumentSnapshot>> readByFilter(String table, String filter) async {
    List<String> parsedFilter = filter.split(':');
    String fieldOfFilter = parsedFilter[0];
    String valueOfFilter = parsedFilter[1];

    return await _firestore
        .collection(table)
        .where(fieldOfFilter, isEqualTo: valueOfFilter)
        .snapshots()
        .first
        .then((QuerySnapshot snapshot) => snapshot.documents)
        .catchError((error) {
          print("Error while reading firestore db, $error");
        });
  }


}