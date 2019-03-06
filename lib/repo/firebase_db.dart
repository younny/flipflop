import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDB{
  final Firestore _firestore;

  static final FirebaseDB _instance = FirebaseDB._internal(Firestore.instance);

  static FirebaseDB get instance => _instance;

  FirebaseDB._internal(this._firestore);

  Future<List<DocumentSnapshot>> create() {
    // TODO: implement create
    return null;
  }

  Future<List<DocumentSnapshot>> delete() {
    // TODO: implement delete
    return null;
  }

  Future<List<DocumentSnapshot>> read(String table) {
    return _firestore
            .collection(table)
            .snapshots()
            .elementAt(0)
            .then((QuerySnapshot snapshot) => snapshot.documents)
            .catchError((error) {
              print("Error while reading firestore db, $error");
            });
  }

  Future<List<DocumentSnapshot>> update() {
    // TODO: implement update
    return null;
  }

  Future<List<DocumentSnapshot>> readByFilter(String table, String filter) {
    List<String> parsedFilter = filter.split(':');
    String fieldOfFilter = parsedFilter[0];
    String valueOfFilter = parsedFilter[1];

    return _firestore
        .collection(table)
        .where(fieldOfFilter, isEqualTo: valueOfFilter.toLowerCase())
        .snapshots()
        .elementAt(0)
        .then((QuerySnapshot snapshot) => snapshot.documents)
        .catchError((error) {
          print("Error while reading firestore db, $error");
        });
  }

}