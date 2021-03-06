import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/constant/error.dart';
import 'package:flipflop/exception.dart';
import 'package:meta/meta.dart';

class FirestoreRepository {
  Firestore _firestore;

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

  Future<List<DocumentSnapshot>> update() {
    // TODO: implement update
    return null;
  }

  Stream<QuerySnapshot> read(String collectionId) {
    return _firestore
        .collection(collectionId)
        .snapshots();
  }

  Stream<QuerySnapshot> readByFilter(String collectionId, String filter) {
    List<String> parsedFilter = filter.split(':');
    if(parsedFilter.isEmpty || parsedFilter.length < 4) {
      throw FirestoreException("${FFError.FIRESTORE} Incorrect filter format.");
    }
    String fieldOfFilter = parsedFilter[0];
    String valueOfFilter = parsedFilter[1].toLowerCase();
    int level = int.parse(parsedFilter[2]);
    String lang = parsedFilter[3];
    try {
      return _firestore
          .collection(collectionId)
          .where(fieldOfFilter, isEqualTo: valueOfFilter.toLowerCase())
          .where("level", isEqualTo: level)
          .where("lang", isEqualTo: lang)
          .snapshots();
    } catch (e) {
      throw FirestoreException("${FFError.FIRESTORE} ${e.toString()}");
    }
  }

  @visibleForTesting
  void withMock(Firestore firestore) {
    _firestore = firestore;
  }
}