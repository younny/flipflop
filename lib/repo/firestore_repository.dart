import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository {
  final Firestore _firestore;

  static final FirestoreRepository _instance = FirestoreRepository._internal(Firestore.instance);

  static FirestoreRepository get instance => _instance;

  FirestoreRepository._internal(this._firestore);

  Future<List<DocumentSnapshot>> create() {
    // TODO: implement create
    return null;
  }

  Future<List<DocumentSnapshot>> delete() {
    // TODO: implement delete
    return null;
  }

  Stream<QuerySnapshot> read(String collectionId) {
    return _firestore
        .collection(collectionId)
        .snapshots();
  }

  Future<List<DocumentSnapshot>> update() {
    // TODO: implement update
    return null;
  }

  Stream<QuerySnapshot> readByFilter(String collectionId, String filter) {
    List<String> parsedFilter = filter.split(':');
    String fieldOfFilter = parsedFilter[0];
    String valueOfFilter = parsedFilter[1].toLowerCase();
    return _firestore
        .collection(collectionId)
        .where(fieldOfFilter, isEqualTo: valueOfFilter.toLowerCase())
        .snapshots();
  }

}